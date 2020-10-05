//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ethan Childerhose
// 
// Create Date: 10/04/2020 09:42:18 PM
// Design Name: 
// Module Name: Top
// Project Name: BigCreteGpu
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Top(    
    //DDR3 passthroughs
    inout [15:0]ddr3_dq,
    inout [1:0]ddr3_dqs_n,
    inout [1:0]ddr3_dqs_p,
    
    output [13:0]ddr3_addr,
    output [2:0]ddr3_ba,
    output ddr3_ras_n,
    output ddr3_cas_n,
    output ddr3_we_n,
    output ddr3_reset_n,
    output ddr3_ck_p,
    output ddr3_ck_n,
    output ddr3_cke,
    output ddr3_cs_n,
    output [1:0]ddr3_dm,
    output ddr3_odt,

    input clk,
    input rst,
    output reg [7:0]led,
    input usb_rx,           // USB->Serial input
    output usb_tx           // USB->Serial output
    );
    
    reg [127:0] wr_data = 16'h0000000000000069;
    reg [15:0] wr_mask = 16'b0;
    reg [27:0] addr = 28'b0;
    wire [127:0] rd_data;
    
    MemController ram(
    //inouts
    .ddr3_dq(ddr3_dq),
    .ddr3_dqs_n(ddr3_dqs_n),
    .ddr3_dqs_p(ddr3_dqs_p),
    
    //outputs
    .ddr3_addr(ddr3_addr),
    .ddr3_ba(ddr3_ba),
    .ddr3_ras_n(ddr3_ras_n),
    .ddr3_cas_n(ddr3_cas_n),
    .ddr3_we_n(ddr3_we_n),
    .ddr3_reset_n(ddr3_reset_n),
    .ddr3_ck_p(ddr3_ck_p),
    .ddr3_ck_n(ddr3_ck_n),
    .ddr3_cke(ddr3_cke),
    .ddr3_cs_n(ddr3_cs_n),
    .ddr3_dm(ddr3_dm),
    .ddr3_odt(ddr3_odt),
    
    .clk(clk),
    .rst(rst),
    .wr_data_ext(wr_data),
    .wr_mask_ext(wr_mask),
    .addr_ext(addr),
    .rd_data(rd_data));
    
    assign usb_tx = usb_rx;  // echo the serial data
    
    assign led = rd_data[7:0];
endmodule
