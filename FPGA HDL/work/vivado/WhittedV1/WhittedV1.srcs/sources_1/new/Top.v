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

    //VGA Outputs
    output wire hSync,
    output wire vSync,
    output reg red,
    output reg blue,
    output reg green,
    
    output reg[11:0] hPix,

    //Peripherals
    input clk,
    input rst,
    output reg [7:0]led,
    input usb_rx,           // USB->Serial input
    output usb_tx           // USB->Serial output
    );
    
    
//module VGADriver(
////VGA stuff
//output reg [7:0]red,
//output reg [7:0]green,
//output reg [7:0]blue,
//output wire hSync,
//output wire vSync,

//output reg [11:0]hPix,
//output reg [10:0]vPix,
//output wire pixelClock,

////Memory Interface
//output reg VGA_request_read,
//output reg [27:0]VGA_addr,
//input wire [127:0]VGA_rd,

//input refClk,
//input rst
    
    reg [7:0]red8;
    reg [7:0]green8;
    reg [7:0]blue8;
    
    assign red = (| red8);
    assign green = (| green8);
    assign blue = (| blue8);
    
    //reg [11:0]hPix;
    //reg [10:0]vPix;
    
    wire pxClk;
    
    wire clk100;
    wire clk200;
    wire clk173;
    wire clkLock;
    
    clk_wiz_0 clk_wiz(    
    .clk_in1(clk),
    .reset(~rst),
    .clk_out1(clk100),
    .clk_out2(clk200),
    .clk_out3(clk173),
    .locked(clkLock)
    );
    
    
    VGADriver disp(
        //8Bit colour output
        .red(red8), 
        .green(green8),
        .blue(blue8),
        
        //Display sync lines 
        .hSync(hSync),
        .vSync(vSync),
        
        //Next driven pixel
        .hPix(hPix),
        .vPix(vPix),
        
        //Pixel clock every pulse it will march onto the next pixel
        .pixelClock(clk173),
        
        //Memory interface
        .VGA_request_read(request_read_vga),
        .VGA_addr(addr_vga),
        .VGA_rd(rd_data_vga),

        //Peripherals
        .rst(rst)
    );

    
    RayTracer RT(
        .RT_request_write(RT_request_write),
        .RT_request_read(RT_request_read),
        .wr_data_rt(wr_data_rt),
        .wr_mask_rt(wr_mask_rt),
        .addr_rt(addr_rt),
        .rd_data_rt(rd_data_rt),
        
        .vgaV(vPix),
        .rst(rst)
    );

    //VGA will exclusively read from memory
    //RayTracer will read and write (maybe just write actually)
    
//    reg request_read_vga;
//    reg [27:0]addr_vga;
//    wire [127:0]rd_data_vga;
    
//    reg RT_request_write;
//    reg RT_request_read;
//    reg [127:0] wr_data_rt;
//    reg [15:0] wr_mask_rt;
//    reg [27:0] addr_rt;
//    wire [127:0] rd_data_rt;
    
    
    
    MemController ram(
    //Peripherals
    .clkLock(clkLock),
    .clk100(clk100),
    .clk200(clk200),
    .rst(rst),
    
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
    
    //Memory connection VGA
    .request_read_vga(request_read_vga),
    .addr_vga(addr_vga),
    .rd_data_vga(rd_data_vga),
    
    //Memory connection ray tracing core
    .request_write_rt(request_write_rt),
    .request_read_rt(request_read_rt),
    .wr_data_rt(wr_data_rt),
    .wr_mask_rt(wr_mask_rt),
    .addr_rt(addr_rt),
    .rd_data_rt(rd_data_rt)
    );
    
    assign usb_tx = usb_rx;  // echo the serial data
    
    //assign led = rd_data[7:0];
endmodule
