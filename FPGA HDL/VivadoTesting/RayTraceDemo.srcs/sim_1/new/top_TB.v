`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2020 08:32:38 PM
// Design Name: 
// Module Name: top_TB
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
`define CLK_PERIOD 10

module top_TB();
    reg button;
    wire L1;
    wire L2;
    wire L3;
    reg clk;
    
    always
       #(`CLK_PERIOD / 2.0) clk <= ~clk;
    
    initial begin
        clk <= 0;
        button <= 0;
        #500;
        
        if(L1 | L2 | L3 !== 0)
            $display("err1");

        #500;
        button <= 1;
        #500;
        
        if(L1 !== 1 | (L2 | L3 !== 0))
            $display("err2");
            
        button <= 0;
        #500;
        button <= 1;
        #500;
        
        if(L2 !== 1 | (L1 | L3 !== 0))
            $display("err3");
            
        button <= 0;
        #500;
        button <= 1;
        #500;
        
        if((L2 & L1) !== 1 | (L3 !== 0))
            $display("err4");

        button <= 0;
        #500;
        button <= 1;
        #500;
        
        if(L3 !== 1 | (L2 | L1 !== 0))
            $display("err5");
            
        button <= 0;
        #500;
        button <= 1;
        #500;
        
        if((L3 & L1) !== 1 | (L2 !== 0))
            $display("err6");

        button <= 0;
        #500;
        button <= 1;
        #500;
        
        if((L3 & L2) !== 1 | (L1 !== 0))
            $display("err7");

        button <= 0;
        #500;
        button <= 1;
        #500;
        
        if((L3 & L2 & L1) !== 1)
            $display("err8");
    end
    
    top t(.button(button), .led1(L1), .led2(L2), .led3(L3), .clk(clk)); 

endmodule
