`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2020 01:46:43 AM
// Design Name: 
// Module Name: ramToVGA
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


module ramToVGA(
    input wire [119:0] ramIn,
    output reg [119:0] vgaOut,
    output reg encoded,
    input wire req,
    input wire ready
    );
    
    initial fork
        encoded = 0;
        vgaOut = 0;
    join
    
    //req is pulled high when encoded is low to enable a write
    //encoded will be pulled high once complete at which point req should be pulled low
    //results can be pulled when ready is pulled low then put high once done pulling results
    always @(*) fork
        if(req & ready) begin
            vgaOut <= ramIn;
            encoded <= 1;
        end
        if(~req & ready)
            encoded <= 0;
    join
        
endmodule
