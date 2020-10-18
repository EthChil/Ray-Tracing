`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2020 08:26:30 PM
// Design Name: 
// Module Name: VGA_TB
// Project Name: 
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


module VGA_TB();   
    wire [7:0] red;
    wire [7:0] green;
    wire [7:0] blue;
    
    wire hSync;
    wire vSync;
    
    wire [7:0] led;
    reg rst;

    reg clk = 0;
    
    initial begin
        rst = 1;
    end
    
    always 
        #5 clk <= ~clk;

    
    clk_wiz_0 clk_wiz(    
        .clk_in1(clk),
        .reset(~rst),
        .clk_out1(clk100),
        .clk_out2(clk200),
        .clk_out3(clk173),
        .locked(clkLock)
    );
    
    VGADriver vga(
        //8Bit colour output
        .red(red8), 
        .green(green8),
        .blue(blue8),
        
        //Display sync lines 
        .hSync(hSync),
        .vSync(vSync),
        
        //Next driven pixel
        .vPix(vPix),
        
        //Pixel clock every pulse it will march onto the next pixel
        .pixelClock(clk173),
        
        //Memory interface
        .request_read(request_read_vga_out),
        .read_complete(read_complete_vga_in),
        
        .VGA_addr(addr_vga_a),
        .VGA_rd(rd_data_vga_b),

        //Peripherals
        .rst(rst),
        .led(led)
    );
    
    assign red = (| red8);
    assign green = (| green8);
    assign blue = (| blue8);
endmodule
