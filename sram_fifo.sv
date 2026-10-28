module sram_fifo #(
    parameter DATA_WIDTH    = 64,
    parameter FIFO_DEPTH    = 4,
    parameter BUF_PTR_WIDTH = $clog2(FIFO_DEPTH),
    parameter SRAM_DEPTH    = 1024,
    parameter SRAM_ADDR_W   = $clog2(SRAM_DEPTH)
)(
    input  wire                    w_clk,
    input  wire                    reset_i,

    input  wire                    wr_en_i,
    input  wire                    rd_en_i,

    input  wire [DATA_WIDTH-1:0]   write_data_i,
    output logic [DATA_WIDTH-1:0]  read_data_o,

    output logic                   sram_full_o,
    output logic                   sram_empty_o,
    output logic                   sram_empty_atb_o
);

    // =========================================================
    // Parameters
    // =========================================================

    localparam integer PACK_WIDTH = 128;
    
    // =========================================================
    //  64-bit -> 128-bit PACKER
    //    SRAM word = {T1[127:64], T0[63:0]}
    // =========================================================
    logic [31:0] sram_Q0, sram_Q1, sram_Q2, sram_Q3;

    logic [DATA_WIDTH-1:0] pack_data;
    logic                  pack_valid;

    logic                  packet_complete;
    logic [PACK_WIDTH-1:0] packet_data;

    assign packet_complete = wr_en_i && pack_valid;
    assign packet_data     = { write_data_i, pack_data };   // {T1, T0}

    // =========================================================
    //  Pending 128-bit WRITE BUFFER  (depth = FIFO_DEPTH)
    // =========================================================

    logic [PACK_WIDTH-1:0]    write_buf [FIFO_DEPTH-1:0];

    logic [BUF_PTR_WIDTH-1:0] write_buf_wr_ptr;
    logic [BUF_PTR_WIDTH-1:0] write_buf_rd_ptr;
    logic [BUF_PTR_WIDTH:0]   write_buf_count;

    logic write_buf_empty;
    logic write_buf_full;

    assign write_buf_empty   = (write_buf_count == {BUF_PTR_WIDTH+1{1'b0}});
    assign write_buf_full    = (write_buf_count == (BUF_PTR_WIDTH+1)'(FIFO_DEPTH));

    logic [PACK_WIDTH-1:0] write_buf_rd_data;
    assign write_buf_rd_data = write_buf[write_buf_rd_ptr];

    // =========================================================
    //  SRAM READ / WRITE POINTERS  (toggle-bit full/empty)
    // =========================================================

    logic [SRAM_ADDR_W-1:0] sram_wr_ptr;
    logic [SRAM_ADDR_W-1:0] sram_rd_ptr;
    logic                   sram_wr_toggle;
    logic                   sram_rd_toggle;
    logic                   sram_empty;
    logic                   sram_full;

    always_comb begin
        sram_empty = (sram_wr_ptr == sram_rd_ptr) &&
                     (sram_wr_toggle == sram_rd_toggle);
        sram_full  = (sram_wr_ptr == sram_rd_ptr) &&
                     (sram_wr_toggle != sram_rd_toggle);
    end

//    assign sram_empty_o = sram_empty;
    assign sram_full_o  = sram_full;
    
    // =========================================================
    //  SRAM OPERATION SIGNALS
    // =========================================================

    logic                   sram_read_fire;
    logic                   sram_write_fire;

    logic [SRAM_ADDR_W-1:0] sram_op_addr;
    logic                   sram_op_web;
    logic [PACK_WIDTH-1:0]  sram_op_data;


    logic [PACK_WIDTH-1:0] read_data_128;
    logic                  read_word_valid;
    logic                  read_high_valid;
    logic                  sram_read_pending;
logic read_high_valid_q;

    // t0_consumed: rd_en_i taking the low half (T0)
    logic t0_consumed;
    assign t0_consumed = rd_en_i && read_word_valid && !read_high_valid;

    // t1_consumed: rd_en_i taking the high half (T1)
    logic t1_consumed;
    assign t1_consumed = rd_en_i && read_word_valid && read_high_valid;


localparam integer EMPTY_STRETCH    = 4;   // extra cycles to hold low
localparam integer STRETCH_W        = $clog2(EMPTY_STRETCH + 1);

logic                    true_empty;
logic [STRETCH_W-1:0]    stretch_cnt;

assign sram_empty_o = sram_empty && !read_word_valid;

// true empty: SRAM array drained AND read register empty
assign true_empty = sram_empty && !read_word_valid;

always_ff @(posedge w_clk or negedge reset_i) begin
    if (!reset_i) begin
        stretch_cnt <= {STRETCH_W{1'b0}};
    end
    else begin
        if (!true_empty) begin
            // Data still present reload counter so it is
            // ready to stretch the moment empty first arrives
            stretch_cnt <= STRETCH_W'(EMPTY_STRETCH);
        end
        else if (stretch_cnt != {STRETCH_W{1'b0}}) begin
            // true_empty just went high count down
            stretch_cnt <= stretch_cnt - {{STRETCH_W-1{1'b0}},1'b1};
        end
    end
end

// Hold empty_o low while counter is running
assign sram_empty_atb_o = true_empty && (stretch_cnt == '0);

    logic read_buf_occupied;
    assign read_buf_occupied = read_word_valid || sram_read_pending;

    // =========================================================
    //  SRAM OPERATION ARBITRATION
    //
    //   Priority 1: Write drain when buffer full + packet ready
    //   Priority 2: Speculative READ pre-fetch (no rd_en needed)
    //               Fires as soon as buffer free + SRAM not empty
    //               INCLUDING on the same cycle T1 is consumed
    //   Priority 3: Background write drain
    // =========================================================

    always_comb begin

        sram_read_fire  = 1'b0;
        sram_write_fire = 1'b0;
        sram_op_addr    = '0;
        sram_op_web     = 1'b1;
        sram_op_data    = '0;

        // Priority 1: free a write buffer slot immediately
        if (packet_complete && write_buf_full && !sram_full) begin
            sram_write_fire = 1'b1;
            sram_op_addr    = sram_wr_ptr;
            sram_op_web     = 1'b0;
            sram_op_data    = write_buf_rd_data;
        end

        // Priority 2: speculative read pre-fetch
        // Fires when register is empty AND no SRAM read in-flight.
        // Fires 1 cycle after T1 consumed (read_word_valid=0).
        // Pre-loads next word well before consumer sends rd_en_i.
        else if (!sram_empty && !read_buf_occupied) begin
            sram_read_fire = 1'b1;
            sram_op_addr   = sram_rd_ptr;
            sram_op_web    = 1'b1;
        end

        // Priority 3: background write drain
        else if (!write_buf_empty && !sram_full) begin
            sram_write_fire = 1'b1;
            sram_op_addr    = sram_wr_ptr;
            sram_op_web     = 1'b0;
            sram_op_data    = write_buf_rd_data;
        end

    end

    // =========================================================
    //  PACKER + WRITE BUFFER
    // =========================================================

    logic sram_wr_bufnot_empty;
    assign sram_wr_bufnot_empty = sram_write_fire && !write_buf_empty;

    always_ff @(posedge w_clk or negedge reset_i) begin

        if (!reset_i) begin
            pack_data        <= {DATA_WIDTH{1'b0}};
            pack_valid       <= 1'b0;
            write_buf_wr_ptr <= {BUF_PTR_WIDTH{1'b0}};
            write_buf_rd_ptr <= {BUF_PTR_WIDTH{1'b0}};
            write_buf_count  <= {BUF_PTR_WIDTH+1{1'b0}};
            for(int i=0; i<FIFO_DEPTH; i=i+1) 
                write_buf[i] <= {PACK_WIDTH{1'b0}}; 
        end

        else begin

            if (wr_en_i) begin
                if (!pack_valid) begin
                    pack_data  <= write_data_i;
                    pack_valid <= 1'b1;
                end else begin
                    pack_valid <= 1'b0;
                end
            end

            case ({sram_wr_bufnot_empty , packet_complete })

                2'b10: begin
                    write_buf_rd_ptr <= (write_buf_rd_ptr == BUF_PTR_WIDTH'(FIFO_DEPTH-1))
                                        ? {BUF_PTR_WIDTH{1'b0}} : write_buf_rd_ptr + {{BUF_PTR_WIDTH-1{1'b0}},1'b1};
                    write_buf_count  <= write_buf_count - {{BUF_PTR_WIDTH{1'b0}},1'b1};
                end

                2'b01: begin
                    if (!write_buf_full) begin
                        write_buf[write_buf_wr_ptr] <= packet_data;
                        write_buf_wr_ptr <= (write_buf_wr_ptr == BUF_PTR_WIDTH'(FIFO_DEPTH-1))
                                            ? {BUF_PTR_WIDTH{1'b0}} : write_buf_wr_ptr + {{BUF_PTR_WIDTH-1{1'b0}},1'b1};
                        write_buf_count  <= write_buf_count + {{BUF_PTR_WIDTH{1'b0}},1'b1};
                    end
                end

                2'b11: begin
                    write_buf[write_buf_wr_ptr] <= packet_data;
                    write_buf_wr_ptr <= (write_buf_wr_ptr == BUF_PTR_WIDTH'(FIFO_DEPTH-1))
                                        ? {BUF_PTR_WIDTH{1'b0}} : write_buf_wr_ptr + {{BUF_PTR_WIDTH-1{1'b0}},1'b1};
                    write_buf_rd_ptr <= (write_buf_rd_ptr == BUF_PTR_WIDTH'(FIFO_DEPTH-1))
                                        ? {BUF_PTR_WIDTH{1'b0}} : write_buf_rd_ptr + {{BUF_PTR_WIDTH-1{1'b0}},1'b1};
                end

                default: begin
                            write_buf[write_buf_wr_ptr] <= write_buf[write_buf_wr_ptr];
                            write_buf_wr_ptr <= write_buf_wr_ptr;
                            write_buf_rd_ptr <= write_buf_rd_ptr;
                            write_buf_count <= write_buf_count;
                end

            endcase

        end

    end

    // =========================================================
    //  SRAM POINTER MANAGEMENT
    // =========================================================

    always_ff @(posedge w_clk or negedge reset_i) begin

        if (!reset_i) begin
            sram_wr_ptr    <= {SRAM_ADDR_W{1'b0}};
            sram_rd_ptr    <= {SRAM_ADDR_W{1'b0}};
            sram_wr_toggle <= 1'b0;
            sram_rd_toggle <= 1'b0;
        end

        else begin

            if (sram_write_fire) begin
                if (sram_wr_ptr == SRAM_ADDR_W'(SRAM_DEPTH-1)) begin
                    sram_wr_ptr    <= {SRAM_ADDR_W{1'b0}};
                    sram_wr_toggle <= ~sram_wr_toggle;
                end else
                    sram_wr_ptr <= sram_wr_ptr + {{SRAM_ADDR_W-1{1'b0}},1'b1};
            end

            if (sram_read_fire) begin
                if (sram_rd_ptr == SRAM_ADDR_W'(SRAM_DEPTH-1)) begin
                    sram_rd_ptr    <= {SRAM_ADDR_W{1'b0}};
                    sram_rd_toggle <= ~sram_rd_toggle;
                end else
                    sram_rd_ptr <= sram_rd_ptr + {{SRAM_ADDR_W-1{1'b0}},1'b1};
            end

        end

    end


    always_ff @(posedge w_clk or negedge reset_i) begin

        if (!reset_i) begin
            read_data_128     <= {PACK_WIDTH{1'b0}};
            read_word_valid   <= 1'b0;
            read_high_valid   <= 1'b0;
            sram_read_pending <= 1'b0;
        end

        else begin

            // Track SRAM read pipeline: Q valid next cycle
            sram_read_pending <= sram_read_fire;

            // --------------------------------------------------
            // PRIORITY 1: Capture fresh SRAM Q
            // --------------------------------------------------
            if (sram_read_pending) begin
                read_data_128   <= { sram_Q3, sram_Q2,
                                     sram_Q1, sram_Q0 };
                read_word_valid <= 1'b1;
                read_high_valid <= 1'b0;
                // read_data_o will drive T0=[63:0] combinationally
                // in the same cycle Â ready with zero extra latency
            end

            // --------------------------------------------------
            // PRIORITY 2: Advance half-word pointer on rd_en_i
            //
            // Happens in the SAME cycle as rd_en_i.
            // read_data_o is combinational so it still shows the
            // OLD value during this cycle (pre-clock-edge).
            // Consumer captures next cycle = correct value. ?
            //
            // T0 taken: flip to high half, word still valid
            // T1 taken: clear word, next pre-fetch already fired
            // --------------------------------------------------
            else if (t0_consumed) begin
                read_high_valid <= 1'b1;
                // read_word_valid stays 1, T1 now on output
            end

            else if (t1_consumed) begin
                read_word_valid <= 1'b0;
                read_high_valid <= 1'b0;
                // read_buf_occupied clears next cycle (registered).
                // sram_read_fire will assert next cycle automatically.
            end

        end

    end


    always_ff@(posedge w_clk or negedge reset_i) begin
        if(!reset_i) begin
            read_high_valid_q <= 1'b0;
        end else begin
            read_high_valid_q <= read_high_valid;
        end
   end

    always_ff@(posedge w_clk or negedge reset_i) begin
        if(!reset_i) begin
            read_data_o <= {DATA_WIDTH{1'b0}};
        end else begin
            read_data_o <= read_high_valid_q ? read_data_128[127:64]  // T1
                                          : read_data_128[63:0];   // T0

        end
   end



/*
    always_comb begin
//        read_data_o = '0;
        if (read_word_valid) begin
            read_data_o = read_high_valid_q ? read_data_128[127:64]  // T1
                                          : read_data_128[63:0];   // T0
        end
        else begin
            read_data_o = '0;//read_data_o;
        end
    end
*/

    // =========================================================
    //  SRAM INTERFACE
    // =========================================================

    logic                   sram_CEB;
    logic                   sram_WEB;
    logic [SRAM_ADDR_W-1:0] sram_A;
    logic [127:0]           sram_D;

    assign sram_CEB = 1'b0;
    assign sram_WEB = sram_op_web;
    assign sram_A   = sram_op_addr;
    assign sram_D   = sram_op_data;

    // =========================================================
    //  FOUR 32-BIT SRAM MACROS  ->  1024x128 logical SRAM
    // =========================================================


    TS1N65LPHSA1024X32M4F u_sram0_core_trace (
        .CLK(w_clk), 
        .CEB(sram_CEB), 
        .WEB(sram_WEB), 
        .A(sram_A),
        .D(sram_D[31:0]),   
        .BWEB(32'h0000_0000), 
        .Q(sram_Q0),
        // DFT signals
        .BIST(1'b0), 
        .AM(10'h0), 
        .DM(32'h0), 
        .BWEBM(32'hFFFF_FFFF), //acitve low
        .WEBM(1'b1), //acitve low
        .CEBM(1'b1), //acitve low
        .AWT(1'b0), // asynchronous write if high
        .RTSEL(2'b00), 
        .WTSEL(3'b000)
    );
    TS1N65LPHSA1024X32M4F u_sram1_core_trace (
        .CLK(w_clk), 
        .CEB(sram_CEB), 
        .WEB(sram_WEB), 
        .A(sram_A),
        .D(sram_D[63:32]),  
        .BWEB(32'h0000_0000), 
        .Q(sram_Q1),
        // DFT signals
        .BIST(1'b0), 
        .AM(10'h0), 
        .DM(32'h0), 
        .BWEBM(32'hFFFF_FFFF), //acitve low
        .WEBM(1'b1), //acitve low
        .CEBM(1'b1), //acitve low
        .AWT(1'b0), // asynchronous write if high
        .RTSEL(2'b00), 
        .WTSEL(3'b000)
    );
    TS1N65LPHSA1024X32M4F u_sram2_core_trace (
        .CLK(w_clk), 
        .CEB(sram_CEB), 
        .WEB(sram_WEB), 
        .A(sram_A),
        .D(sram_D[95:64]),  
        .BWEB(32'h0000_0000), 
        .Q(sram_Q2),
        // DFT signals
        .BIST(1'b0), 
        .AM(10'h0), 
        .DM(32'h0), 
        .BWEBM(32'hFFFF_FFFF), //acitve low
        .WEBM(1'b1), //acitve low
        .CEBM(1'b1), //acitve low
        .AWT(1'b0), // asynchronous write if high
        .RTSEL(2'b00), 
        .WTSEL(3'b000)
    );
    TS1N65LPHSA1024X32M4F u_sram3_core_trace (
        .CLK(w_clk), 
        .CEB(sram_CEB), 
        .WEB(sram_WEB), 
        .A(sram_A),
        .D(sram_D[127:96]), 
        .BWEB(32'h0000_0000), 
        .Q(sram_Q3),
        // DFT signals
        .BIST(1'b0), 
        .AM(10'h0), 
        .DM(32'h0), 
        .BWEBM(32'hFFFF_FFFF), //acitve low
        .WEBM(1'b1),  //acitve low
        .CEBM(1'b1), //acitve low
        .AWT(1'b0), // asynchronous write if high
        .RTSEL(2'b00), 
        .WTSEL(3'b000)
    );

endmodule
