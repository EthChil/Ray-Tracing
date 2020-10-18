`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2020 03:09:09 PM
// Design Name: 
// Module Name: topTB
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


module topTB();
    reg clkEx = 0;
    wire [7:0]led;
    wire hSync;
    wire vSync;
    wire [11:0]hPix;
    wire [10:0]vPix;
    
    always 
        #5 clkEx <= ~clkEx;
    
    Top tester(.clk(clkEx), .led(led), .hSync(hSync), .vSync(vSync));

endmodule