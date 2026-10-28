
module apb_slave_reg_core_trace #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 32
)(
    
    input  logic                     pclk_i,
    input  logic                     presetn_i,

    input  logic [ADDR_WIDTH-1:0]    paddr_i,
    input  logic                     psel_i,
    input  logic                     penable_i,
    input  logic                     pwrite_i,
    input  logic [1:0]               pwdata_i,

    input  logic                     sram_full_i,
    input  logic                     sram_empty_i,

    output logic [DATA_WIDTH-1:0]    prdata_o,
    output logic                     pready_o,
    output logic                     pslverr_o,


    // CORE_TRACE_CTRL bit 0
    output logic                     core_trace_ctrl_reg_o,

    // CORE_TRACE_CTRL bit 1
    // 0 = 8-bit ATB mode
    // 1 = 16-bit ATB mode
    output logic                     atb_mode_reg_o
);


    localparam ADDR_CORE_TRACE_CTRL =
                    {{ADDR_WIDTH-4{1'b0}}, 4'h0};
    localparam STATUS_CORE_TRACE = 
                    {{ADDR_WIDTH-4{1'b0}}, 4'h4};


  

    logic core_trace_reg_ctrl_q;
    logic atb_mode_q;


    logic                    psel_q;
    logic                    penable_q;
    logic [ADDR_WIDTH-1:0]   paddr_q;
    logic                    pwrite_q;


       always_ff @(posedge pclk_i or negedge presetn_i) begin
        if (!presetn_i)
        begin
            psel_q    <= 1'b0;
            penable_q <= 1'b0;
            paddr_q   <= {ADDR_WIDTH{1'b0}};
            pwrite_q  <= 1'b0;
        end
        else
        begin
            psel_q    <= psel_i;
            penable_q <= penable_i;
            paddr_q   <= paddr_i;
            pwrite_q  <= pwrite_i;
        end
    end


    logic write_en;
    logic access_en;

    assign write_en  = psel_q & penable_q & pwrite_q;
    assign access_en = psel_q & penable_q;


    
    logic addr_valid;

    always_comb
    begin
        case (paddr_q)

            ADDR_CORE_TRACE_CTRL, STATUS_CORE_TRACE:
                addr_valid = 1'b1;

            default:
                addr_valid = 1'b0;

        endcase
    end


    always_ff @(posedge pclk_i or negedge presetn_i)
    begin
        if (!presetn_i)
        begin
            pready_o <= 1'b0;
        end
        else if ((psel_q & penable_q) & (psel_i & penable_i))
        begin
            pready_o <= 1'b1;
        end
        else
        begin
            pready_o <= 1'b0;
        end
    end


  logic write_to_ro;
 
  assign write_to_ro = write_en && (paddr_q == STATUS_CORE_TRACE);

  always_ff@(posedge pclk_i or negedge presetn_i) begin
    if(!presetn_i) begin
        pslverr_o <= 1'b0;
    end else if((access_en && ( !addr_valid || write_to_ro)) && psel_i && penable_i) begin
        pslverr_o <= 1'b1;
    end else begin
        pslverr_o <= 1'b0;
    end
  end


        //==========================================================

    always_ff @(posedge pclk_i or negedge presetn_i)
    begin
        if (!presetn_i)
        begin
            core_trace_reg_ctrl_q <= 1'b0;
            atb_mode_q             <= 1'b0;
        end
        else if (write_en)
        begin
            case (paddr_q)

                ADDR_CORE_TRACE_CTRL:
                begin
                    core_trace_reg_ctrl_q <= pwdata_i[0];
                    atb_mode_q             <= pwdata_i[1];
                end

                default:
                begin
                    core_trace_reg_ctrl_q <= core_trace_reg_ctrl_q;
                    atb_mode_q             <= atb_mode_q;
                end

            endcase
        end
    end


 
    assign core_trace_ctrl_reg_o = core_trace_reg_ctrl_q;

    assign atb_mode_reg_o = atb_mode_q;

    logic [1:0] status_q;
    
  always_ff @(posedge pclk_i or negedge presetn_i) begin
    if (!presetn_i) begin
      status_q <= 2'b0;//{DATA_WIDTH{1'b0}};
    end
    else begin
      status_q <= {sram_full_i,sram_empty_i};
    end
  end


    
    always_ff @(posedge pclk_i or negedge presetn_i)
    begin
        if (!presetn_i)
        begin
            prdata_o <= {DATA_WIDTH{1'b0}};
        end
        else if (!pready_o)
        begin

            unique case (paddr_q)

                ADDR_CORE_TRACE_CTRL:
                            begin
                                    prdata_o <= {{DATA_WIDTH-2{1'b0}},atb_mode_q,core_trace_reg_ctrl_q };
                            end
                STATUS_CORE_TRACE: 
                            begin
                                    prdata_o <= {{DATA_WIDTH-2{1'b0}},status_q};
                            end                            

                default:
                begin
                    prdata_o <= {DATA_WIDTH{1'b0}};
                end

            endcase

        end
    end


endmodule
