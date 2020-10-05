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
    
    always 
        #5 clkEx <= ~clkEx;
    
    au_top_0 ram(.clk(clkEx), .led(led));

endmodule
