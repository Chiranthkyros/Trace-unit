
module top_trace #(
    parameter FIFO_DATA_WIDTH = 64,
    parameter FIFO_DEPTH      = 16
)(
    input               it_clk,
    input               it_rst_n,

    input   [3:0]       it_itype,
    input   [15:0]      it_iaddr,
    input   [7:0]       it_cause,
    input   [31:0]      it_tval,
    input   [1:0]       it_context,
    input               it_trace_enable,
    input               it_ienable_in,
    input               it_itype_valid,
    input               it_first_instrn_valid_in,
    input   [19:0]      it_delta_addr,
    input               it_del_adr_valid,

    output  logic            sram_full,
    output  logic            sram_empty,

    
    input               atb_mode_i,

    
    input               afvalid_i,
    output              afready_o,

   
    input               atready_i,
    output  [15:0]      atdata_o,
    output              atvalid_o
);

    wire [63:0] wdata_w;
    wire        wr_en_w;

    wire        fifo_wfull_w;
    wire        fifo_rempty_w;
    wire        fifo_ren_w;
    wire [63:0] fifo_rdata_w;


    inst_trace_enmodule te_inst
    (
        .te_ienable_in          (it_ienable_in),
        .itype_valid_i          (it_itype_valid),
        .itype_in               (it_itype),
        .cause_in               (it_cause),
        .tval_in                (it_tval),
        .iaddr_in               (it_iaddr),
        .context_in             (it_context),
        .delta_addr             (it_delta_addr),
        .del_addr_valid         (it_del_adr_valid),
        .clk                    (it_clk),
        .rst_n                  (it_rst_n),
        .first_instrn_valid_in  (it_first_instrn_valid_in),
        .fifo_wfull             (fifo_wfull_w),
        .te_trace_enable        (it_trace_enable),
        .packet_format3_o       (wdata_w),
        .wr_en_out              (wr_en_w)
    );

//logic rd_data_valid;
logic sram_empty_w;
sram_fifo i_fifo_sram(
                    .w_clk(it_clk),
                    .reset_i(it_rst_n),
                    
                    
                    .wr_en_i(wr_en_w),
                    .write_data_i(wdata_w),
                    
                    
                    .rd_en_i(fifo_ren_w),
                    .read_data_o(fifo_rdata_w),
                    
                    
                    .sram_full_o(fifo_wfull_w),
                    .sram_empty_o(sram_empty_w),
                    .sram_empty_atb_o(fifo_rempty_w)
);

//assign sram_full = fifo_wfull_w;
//assign sram_empty = sram_empty_w;

always_ff@(posedge it_clk or negedge it_rst_n) begin
    if(!it_rst_n) begin
        sram_full <= 1'b0;
        sram_empty <= 1'b0;
    end else begin
        sram_full <= fifo_wfull_w;
        sram_empty <= sram_empty_w;
    end
end


    
    atb_transmitter #(
        .DATA_WIDTH (64),
        .ATID_WIDTH (7),
        .ATID_VALUE (7'h01)
    ) u_atb_transmitter (
        .atclk      (it_clk),
        .atresetn   (it_rst_n),

        
        .tf_rdata   (fifo_rdata_w),
        .tf_rempty  (fifo_rempty_w),
        .tf_ren     (fifo_ren_w),

        
        .afvalid_i  (afvalid_i),
        .afready_o  (afready_o),
        .atb_mode_i (atb_mode_i),
        .atdata_o   (atdata_o),

        .atvalid_o  (atvalid_o),
        .atready_i  (atready_i)
    );

endmodule


