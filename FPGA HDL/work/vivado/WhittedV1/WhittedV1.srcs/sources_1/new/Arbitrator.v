`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2020 04:24:02 PM
// Design Name: 
// Module Name: Arbitrator
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


module Arbitrator(
    input wire requestIn, //from module
    output reg requestOut, //To RAM
    
    input wire completeIn, //from RAM
    output reg completeOut //To module
    );
    
    always @(*) fork
        //request and complete start 0
        //first thing to happen will be VGA will bring the request line high
        //when this happens it will be piped directly to the ram
        
        //R0, C0 (REST) -> (Request)
        if(requestIn & ~completeIn) fork
            requestOut <= 1;
            completeOut <= 0;
        join
        
        //R1, C0 (Request) -> (Done) this is ram driven
    
        //R1, C1 (Done) -> (Reset)
        if(requestIn & completeIn) fork
            completeOut <= 1;
            requestOut <= 0;
        join
        
        //R0, C1 (Reset) -> Rest
        if(~requestIn & completeOut)
            completeOut <= 0;
        
        //R0, C0 again this is then driven by the VGA
    join
    
    
endmodule
