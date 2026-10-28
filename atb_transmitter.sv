/*module atb_transmitter #(
    parameter DATA_WIDTH = 64,
    parameter ATID_WIDTH = 7,
    parameter ATID_VALUE = 7'h01
)(
    //==========================================================
    // Global Signals
    //==========================================================

    input                       atclk,
    input                       atresetn,

    //==========================================================
    // Trace FIFO Interface
    //==========================================================

    input  [DATA_WIDTH-1:0]     tf_rdata,
    input                       tf_rempty,
    output reg                  tf_ren,

    //==========================================================
    // Flush Interface
    //==========================================================

    input                       afvalid_i,
    output reg                  afready_o,

    //==========================================================
    // ATB Interface
    //==========================================================

    output reg [15:0]           atdata_o,
    output reg                  atvalid_o,
    input                       atready_i
);

    //==========================================================
    // State Encoding
    //==========================================================

    localparam ST_IDLE      = 3'd0;
    localparam ST_FIFO_READ = 3'd1;
    localparam ST_FIFO_WAIT = 3'd2;
    localparam ST_CAPTURE   = 3'd3;
    localparam ST_SEND      = 3'd4;
    localparam ST_FLUSH     = 3'd5;


    //==========================================================
    // State Registers
    //==========================================================

    reg [2:0] current_state;
    reg [2:0] next_state;


    //==========================================================
    // Internal Registers
    //==========================================================

    reg [DATA_WIDTH-1:0] packet_reg;

    // 0 = default/no transfer
    // 1 = word 0
    // 2 = word 1
    // 3 = word 2
    // 4 = word 3
    reg [2:0] word_cnt;

    reg flush_pending;


    //==========================================================
    // ATB HANDSHAKE
    //==========================================================

    wire atb_handshake;

    assign atb_handshake = atvalid_o && atready_i;


    //==========================================================
    // CURRENT STATE REGISTER
    //==========================================================

    always @(posedge atclk or negedge atresetn)
    begin
        if (!atresetn)
            current_state <= ST_IDLE;
        else
            current_state <= next_state;
    end


    //==========================================================
    // SEQUENTIAL LOGIC
    //==========================================================

    always @(posedge atclk or negedge atresetn)
    begin
        if (!atresetn)
        begin
            tf_ren        <= 1'b0;
            afready_o     <= 1'b0;
            flush_pending <= 1'b0;

            packet_reg    <= {DATA_WIDTH{1'b0}};
            word_cnt      <= 3'd0;
        end
        else
        begin

            //==================================================
            // Default outputs
            //==================================================

            tf_ren    <= 1'b0;
            afready_o <= 1'b0;


            //==================================================
            // Flush request
            //==================================================

            if (afvalid_i)
                flush_pending <= 1'b1;


            //==================================================
            // State dependent logic
            //==================================================

            case (current_state)

                //================================================
                // IDLE
                //================================================

                ST_IDLE:
                begin
                    // Default value
                    word_cnt <= 3'd0;
                end


                //================================================
                // FIFO READ
                //================================================

                ST_FIFO_READ:
                begin
                    // Generate one-cycle FIFO read enable
                    tf_ren <= 1'b1;
                end


                //================================================
                // FIFO WAIT
                //================================================

                ST_FIFO_WAIT:
                begin
                    tf_ren <= 1'b0;
                end


                //================================================
                // CAPTURE
                //================================================

                ST_CAPTURE:
                begin
                    // Capture complete FIFO packet
                    packet_reg <= tf_rdata;

                    // Start from default state
                    word_cnt <= 3'd0;
                end


                //================================================
                // SEND
                //================================================

                ST_SEND:
                begin
                        if(word_cnt == 3'd0)
                            begin
                            word_cnt <= 3'd1;
                            end


                    //================================================
                    // Advance word counter ONLY after handshake
                    //
                    // 0 -> 1 -> 2 -> 3 -> 4 -> 0
                    //================================================

                 else  if (atb_handshake)
                    begin

                        if (word_cnt == 3'd4)
                        begin
                            // Last word transferred
                            word_cnt <= 3'd0;
                        end
                        else
                        begin
                            // Move to next word
                            word_cnt <= word_cnt + 3'd1;
                        end

                    end

                end


                //================================================
                // FLUSH
                //================================================

                ST_FLUSH:
                begin
                    if (tf_rempty)
                    begin
                        afready_o     <= 1'b1;
                        flush_pending <= 1'b0;
                    end
                end


                //================================================
                // DEFAULT
                //================================================

                default:
                begin
                    word_cnt <= 3'd0;
                end

            endcase

        end
    end


    //==========================================================
    // ATB OUTPUT LOGIC
    //==========================================================
    //
    // word_cnt = 0:
    //     ATVALID = 0
    //     ATDATA  = 0000
    //
    // word_cnt = 1:
    //     DATA[15:0]
    //
    // word_cnt = 2:
    //     DATA[31:16]
    //
    // word_cnt = 3:
    //     DATA[47:32]
    //
    // word_cnt = 4:
    //     DATA[63:48]
    //
    // When ATREADY = 0:
    //     ATDATA = 0000
    //
    //==========================================================

    always @(*)
    begin

        //======================================================
        // Default
        //======================================================

        atvalid_o = 1'b0;
        atdata_o  = 16'h0000;


        //======================================================
        // SEND STATE
        //======================================================

        if (current_state == ST_SEND)
        begin

            //==================================================
            // word_cnt = 0 is default/no-transfer
            //==================================================

            if (word_cnt != 3'd0)
            begin

                //================================================
                // ATVALID is asserted for valid word
                //================================================

                atvalid_o = 1'b1;


                //================================================
                // Data is presented only when ATREADY is HIGH
                //================================================

                if (atready_i)
                begin

                    case (word_cnt)

                        //========================================
                        // Word 1
                        //========================================

                        3'd1:
                            atdata_o = packet_reg[15:0];


                        //========================================
                        // Word 2
                        //========================================

                        3'd2:
                            atdata_o = packet_reg[31:16];


                        //========================================
                        // Word 3
                        //========================================

                        3'd3:
                            atdata_o = packet_reg[47:32];


                        //========================================
                        // Word 4
                        //========================================

                        3'd4:
                            atdata_o = packet_reg[63:48];


                        //========================================
                        // Default
                        //========================================

                        default:
                            atdata_o = 16'h0000;

                    endcase

                end
                else
                begin
                    // Receiver not ready
                    atdata_o = 16'h0000;
                end

            end
            else
            begin

                //================================================
                // word_cnt = 0
                //
                // No transfer
                //================================================

                atvalid_o = 1'b0;
                atdata_o  = 16'h0000;

            end

        end

    end


    //==========================================================
    // NEXT STATE LOGIC
    //==========================================================

    always @(*)
    begin

        next_state = current_state;


        case (current_state)

            //==================================================
            // IDLE
            //==================================================

            ST_IDLE:
            begin

                if (flush_pending)
                begin
                    next_state = ST_FLUSH;
                end
                else if (!tf_rempty)
                begin
                    next_state = ST_FIFO_READ;
                end
                else
                begin
                    next_state = ST_IDLE;
                end

            end


            //==================================================
            // FIFO READ
            //==================================================

            ST_FIFO_READ:
            begin
                next_state = ST_FIFO_WAIT;
            end


            //==================================================
            // FIFO WAIT
            //==================================================

            ST_FIFO_WAIT:
            begin
                next_state = ST_CAPTURE;
            end


            //==================================================
            // CAPTURE
            //==================================================

            ST_CAPTURE:
            begin
                next_state = ST_SEND;
            end


            //==================================================
            // SEND
            //==================================================

            ST_SEND:
            begin

                //================================================
                // First cycle in SEND has word_cnt = 0.
                // Move to word 1 automatically.
                //================================================

                if (word_cnt == 3'd0)
                begin
                   // word_cnt = 3'd1;
                    next_state = ST_SEND;
                end

                //================================================
                // For words 1-4, wait for handshake.
                //================================================

                else if (atb_handshake)
                begin

                    //============================================
                    // Last word
                    //============================================

                    if (word_cnt == 3'd4)
                    begin

                        if (flush_pending)
                        begin
                            if (!tf_rempty)
                                next_state = ST_FIFO_READ;
                            else
                                next_state = ST_FLUSH;
                        end
                        else
                        begin
                            if (!tf_rempty)
                                next_state = ST_FIFO_READ;
                            else
                                next_state = ST_IDLE;
                        end

                    end

                    //============================================
                    // Words 1, 2, 3
                    //============================================

                    else
                    begin
                        next_state = ST_SEND;
                    end

                end

                //================================================
                // No handshake
                //================================================

                else
                begin
                    next_state = ST_SEND;
                end

            end


            //==================================================
            // FLUSH
            //==================================================

            ST_FLUSH:
            begin

                if (!tf_rempty)
                begin
                    next_state = ST_FIFO_READ;
                end
                else
                begin
                    next_state = ST_IDLE;
                end

            end


            //==================================================
            // DEFAULT
            //==================================================

            default:
            begin
                next_state = ST_IDLE;
            end

        endcase

    end

endmodule */


module atb_transmitter #(
    parameter DATA_WIDTH = 64,
    parameter ATID_WIDTH = 7,
    parameter ATID_VALUE = 7'h01
)(
    //==========================================================
    // Global Signals
    //==========================================================

    input                       atclk,
    input                       atresetn,

    //==========================================================
    // Trace FIFO Interface
    //==========================================================

    input  [DATA_WIDTH-1:0]     tf_rdata,
    input                       tf_rempty,
    output reg                  tf_ren,
//    input                       rd_data_valid_i,
    //==========================================================
    // Flush Interface
    //==========================================================

    input                       afvalid_i,
    output reg                  afready_o,

    //==========================================================
    // ATB Configuration
    //==========================================================

    // 0 = 8-bit mode
    // 1 = 16-bit mode
    input                       atb_mode_i,

    //==========================================================
    // ATB Interface
    //==========================================================

    output reg [15:0]           atdata_o,
    output reg                  atvalid_o,
    input                       atready_i
);


    //==========================================================
    // State Encoding
    //==========================================================

    localparam ST_IDLE      = 3'd0;
    localparam ST_FIFO_READ = 3'd1;
    localparam ST_FIFO_WAIT = 3'd2;
    localparam ST_CAPTURE   = 3'd3;
    localparam ST_SEND      = 3'd4;
    localparam ST_FLUSH     = 3'd5;


    //==========================================================
    // State Registers
    //==========================================================

    reg [2:0] current_state;
    reg [2:0] next_state;


    //==========================================================
    // Internal Registers
    //==========================================================

    reg [DATA_WIDTH-1:0] packet_reg;

    //==========================================================
    // Word Counter
    //
    // 0 = default/no transfer
    //
    // 8-bit mode:
    //     1 -> 8 transfers
    //
    // 16-bit mode:
    //     1 -> 4 transfers
    //==========================================================

    reg [3:0] word_cnt;

    reg flush_pending;


    //==========================================================
    // ATB HANDSHAKE
    //==========================================================

    wire atb_handshake;

    assign atb_handshake = atvalid_o && atready_i;


    //==========================================================
    // CURRENT STATE REGISTER
    //==========================================================

    always @(posedge atclk or negedge atresetn)
    begin
        if (!atresetn)
            current_state <= ST_IDLE;
        else
            current_state <= next_state;
    end


    //==========================================================
    // SEQUENTIAL LOGIC
    //==========================================================

    always @(posedge atclk or negedge atresetn)
    begin
        if (!atresetn)
        begin
            tf_ren        <= 1'b0;
            afready_o     <= 1'b0;
            flush_pending <= 1'b0;

            packet_reg    <= {DATA_WIDTH{1'b0}};
            word_cnt      <= 4'd0;
        end
        else
        begin

            //==================================================
            // Default outputs
            //==================================================

            tf_ren    <= 1'b0;
            afready_o <= 1'b0;


            //==================================================
            // Flush request
            //==================================================

            if (afvalid_i)
                flush_pending <= 1'b1;


            //==================================================
            // State dependent logic
            //==================================================

            case (current_state)

                //================================================
                // IDLE
                //================================================

                ST_IDLE:
                begin
                    word_cnt <= 4'd0;
                end


                //================================================
                // FIFO READ
                //================================================

                ST_FIFO_READ:
                begin
                    // Generate one-cycle FIFO read enable
                    tf_ren <= 1'b1;
                end


                //================================================
                // FIFO WAIT
                //================================================

                ST_FIFO_WAIT:
                begin
                    tf_ren <= 1'b0;
                end


                //================================================
                // CAPTURE
                //================================================

                ST_CAPTURE:
                begin
                    // Capture complete FIFO packet
                    packet_reg <= tf_rdata;

                    // Start from default state
                    word_cnt <= 4'd0;
                end


                //================================================
                // SEND
                //================================================

                ST_SEND:
                begin

                    //================================================
                    // First cycle in SEND
                    //
                    // word_cnt = 0
                    // Move to first transfer
                    //================================================

                    if (word_cnt == 4'd0)
                    begin
                        word_cnt <= 4'd1;
                    end

                    //================================================
                    // Advance word counter ONLY after handshake
                    //
                    // 8-bit mode:
                    //     1 -> 2 -> 3 -> 4 -> 5 -> 6 -> 7 -> 8
                    //
                    // 16-bit mode:
                    //     1 -> 2 -> 3 -> 4
                    //================================================

                    else if (atb_handshake)
                    begin

                        //================================================
                        // Last transfer depends on ATB mode
                        //================================================

                        if ((!atb_mode_i && (word_cnt == 4'd8)) ||
                            ( atb_mode_i && (word_cnt == 4'd4)))
                        begin
                            // Last word transferred
                            word_cnt <= 4'd0;
                        end
                        else
                        begin
                            // Move to next word
                            word_cnt <= word_cnt + 4'd1;
                        end

                    end

                end


                //================================================
                // FLUSH
                //================================================

                ST_FLUSH:
                begin
                    if (tf_rempty)
                    begin
                        afready_o     <= 1'b1;
                        flush_pending <= 1'b0;
                    end
                end


                //================================================
                // DEFAULT
                //================================================

                default:
                begin
                    word_cnt <= 4'd0;
                end

            endcase

        end
    end


    //==========================================================
    // ATB OUTPUT LOGIC
    //
    // ATB MODE = 0 : 8-bit mode
    //
    // Each byte is transferred in ATDATA[15:8].
    // ATDATA[7:0] is always 8'h00.
    //
    // packet_reg[7:0]   -> word 1
    // packet_reg[15:8]  -> word 2
    // packet_reg[23:16] -> word 3
    // packet_reg[31:24] -> word 4
    // packet_reg[39:32] -> word 5
    // packet_reg[47:40] -> word 6
    // packet_reg[55:48] -> word 7
    // packet_reg[63:56] -> word 8
    //
    //
    // ATB MODE = 1 : 16-bit mode
    //
    // packet_reg[15:0]  -> word 1
    // packet_reg[31:16] -> word 2
    // packet_reg[47:32] -> word 3
    // packet_reg[63:48] -> word 4
    //
    //
    // When ATREADY = 0:
    //     ATDATA = 16'h0000
    //
    //==========================================================

    always @(*)
    begin

        //======================================================
        // Default
        //======================================================

        atvalid_o = 1'b0;
        atdata_o  = 16'h0000;


        //======================================================
        // SEND STATE
        //======================================================

        if (current_state == ST_SEND)
        begin

            //==================================================
            // word_cnt = 0 is default/no-transfer
            //==================================================

            if (word_cnt != 4'd0)
            begin

                //================================================
                // ATVALID is asserted for valid word
                //================================================

                atvalid_o = 1'b1;


                //================================================
                // Data is presented only when ATREADY is HIGH
                //================================================

                if (atready_i)
                begin

                    case (word_cnt)

                        //========================================
                        // Transfer 1
                        //========================================

                        4'd1:
                        begin
                            if (!atb_mode_i)
                                atdata_o = {packet_reg[7:0], 8'h00};
                            else
                                atdata_o = packet_reg[15:0];
                        end


                        //========================================
                        // Transfer 2
                        //========================================

                        4'd2:
                        begin
                            if (!atb_mode_i)
                                atdata_o = {packet_reg[15:8], 8'h00};
                            else
                                atdata_o = packet_reg[31:16];
                        end


                        //========================================
                        // Transfer 3
                        //========================================

                        4'd3:
                        begin
                            if (!atb_mode_i)
                                atdata_o = {packet_reg[23:16], 8'h00};
                            else
                                atdata_o = packet_reg[47:32];
                        end


                        //========================================
                        // Transfer 4
                        //========================================

                        4'd4:
                        begin
                            if (!atb_mode_i)
                                atdata_o = {packet_reg[31:24], 8'h00};
                            else
                                atdata_o = packet_reg[63:48];
                        end


                        //========================================
                        // Transfer 5
                        // 8-bit mode only
                        //========================================

                        4'd5:
                        begin
                            if (!atb_mode_i)
                                atdata_o = {packet_reg[39:32], 8'h00};
                            else
                                atdata_o = 16'h0000;
                        end


                        //========================================
                        // Transfer 6
                        // 8-bit mode only
                        //========================================

                        4'd6:
                        begin
                            if (!atb_mode_i)
                                atdata_o = {packet_reg[47:40], 8'h00};
                            else
                                atdata_o = 16'h0000;
                        end


                        //========================================
                        // Transfer 7
                        // 8-bit mode only
                        //========================================

                        4'd7:
                        begin
                            if (!atb_mode_i)
                                atdata_o = {packet_reg[55:48], 8'h00};
                            else
                                atdata_o = 16'h0000;
                        end


                        //========================================
                        // Transfer 8
                        // 8-bit mode only
                        //========================================

                        4'd8:
                        begin
                            if (!atb_mode_i)
                                atdata_o = {packet_reg[63:56], 8'h00};
                            else
                                atdata_o = 16'h0000;
                        end


                        //========================================
                        // Default
                        //========================================

                        default:
                            atdata_o = 16'h0000;

                    endcase

                end
                else
                begin

                    //================================================
                    // Receiver not ready
                    //================================================

                    atdata_o = 16'h0000;

                end

            end
            else
            begin

                //================================================
                // word_cnt = 0
                //
                // No transfer
                //================================================

                atvalid_o = 1'b0;
                atdata_o  = 16'h0000;

            end

        end

    end


    //==========================================================
    // NEXT STATE LOGIC
    //==========================================================

    always @(*)
    begin

        next_state = current_state;


        case (current_state)

            //==================================================
            // IDLE
            //==================================================

            ST_IDLE:
            begin

                if (flush_pending)
                begin
                    next_state = ST_FLUSH;
                end
                else if (!tf_rempty)
                begin
                    next_state = ST_FIFO_READ;
                end
                else
                begin
                    next_state = ST_IDLE;
                end

            end


            //==================================================
            // FIFO READ
            //==================================================

            ST_FIFO_READ:
            begin
                next_state = ST_FIFO_WAIT;
            end


            //==================================================
            // FIFO WAIT
            //==================================================

            ST_FIFO_WAIT:
            begin
                next_state = ST_CAPTURE;
            end


            //==================================================
            // CAPTURE
            //==================================================

            ST_CAPTURE:
            begin
//                if(rd_data_valid_i) begin
                    next_state = ST_SEND;
//                end else begin
//                    next_state = ST_CAPTURE;
//                end
            end


            //==================================================
            // SEND
            //==================================================

            ST_SEND:
            begin

                //================================================
                // First cycle in SEND has word_cnt = 0.
                //
                // Move to word 1 automatically.
                //================================================

                if (word_cnt == 4'd0)
                begin
                    next_state = ST_SEND;
                end

                //================================================
                // For valid words, wait for handshake.
                //================================================

                else if (atb_handshake)
                begin

                    //============================================
                    // Last word depends on ATB mode
                    //============================================

                    if ((!atb_mode_i && (word_cnt == 4'd8)) ||
                        ( atb_mode_i && (word_cnt == 4'd4)))
                    begin

                        if (flush_pending)
                        begin
                            if (!tf_rempty)
                                next_state = ST_FIFO_READ;
                            else
                                next_state = ST_FLUSH;
                        end
                        else
                        begin
                            if (!tf_rempty)
                                next_state = ST_FIFO_READ;
                            else
                                next_state = ST_IDLE;
                        end

                    end

                    //============================================
                    // Not the last word
                    //============================================

                    else
                    begin
                        next_state = ST_SEND;
                    end

                end

                //================================================
                // No handshake
                //================================================

                else
                begin
                    next_state = ST_SEND;
                end

            end


            //==================================================
            // FLUSH
            //==================================================

            ST_FLUSH:
            begin

                if (!tf_rempty)
                begin
                    next_state = ST_FIFO_READ;
                end
                else
                begin
                    next_state = ST_IDLE;
                end

            end


            //==================================================
            // DEFAULT
            //==================================================

            default:
            begin
                next_state = ST_IDLE;
            end

        endcase

    end


endmodule

