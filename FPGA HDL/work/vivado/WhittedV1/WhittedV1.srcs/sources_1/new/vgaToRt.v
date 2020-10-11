`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2020 12:10:33 AM
// Design Name: 
// Module Name: vga2rt
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


module vgaToRt(
    input wire [10:0] vgaIn,
    output reg [10:0] rtOut,
    output reg encoded,
    input wire req,
    input wire ready
    );
    
    initial fork
        encoded = 0;
        rtOut = 0;
    join
    
    always @(*) fork
        if(req & ready) begin
            rtOut <= vgaIn;
            encoded <= 1;
        end
        if(~req & ready)
            encoded <= 0;
    join
    
endmodule
