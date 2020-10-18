`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2020 01:55:59 PM
// Design Name: 
// Module Name: ram_write_arbitrator
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


module ram_write_arbitrator(
    input wire [27:0] addr_in,
    output reg [27:0] addr_out,
    
    input wire [15:0] wr_mask_in,
    output reg [15:0] wr_mask_out,
    
    input wire [127:0] wr_in,
    output reg [127:0] wr_out, 

    input wire requestIn, //from module
    output reg requestOut, //To RAM
    
    input wire completeIn, //from RAM
    output reg completeOut //To module
    
    //input wire rst
    );
    
    initial fork
        addr_out = 0;
        wr_mask_out = 0;
        wr_out = 0;
        
        requestOut = 0;
        completeOut = 0;
    join
    
    always @(completeIn, requestIn) begin
//        if(~rst) fork
//            addr_out <= 0;
//            wr_mask_out <= 0;
//            wr_out <= 0;
        
//            requestOut <= 0;
//            completeOut <= 0;
//        join
    
        //| rt  |   ram    |    ram    |    rt      |      rt     |     ram      |
        //|=====|==========|===========|============|=============|==============|
        //| req | complete | read addr | write addr | read result | write result |
        //|-----|----------|-----------|------------|-------------|--------------|
        //| R0  |    C0    |     no    |     yes    |      no     |      no      | wait for write
        //| R1  |    C0    |     yes   |     no     |      no     |      yes     | wait for ram
        //| R1  |    C1    |     no    |     no     |      yes    |      no      | wait for vga
        //| R0  |    C1    |     no    |     no     |      no     |      no      | sync
        //| R0  |    C0    |     no    |     yes    |      no     |      no      | wait for write
        //|=====|==========|===========|============|=============|==============|
        
        //RAM Side
        
        
        //request and complete start 0
        //first thing to happen will be VGA will bring the request line high and load into the addr reg
        //when this happens it will be piped directly to the ram and the addr reg will be loaded
        //next the ram will sit and eventually pull the data down and then populate the read at which point the complete will go high
        //this will then mean that the VGA will pull the data down and put request low
        //next ram will pull it's complete low and the cycle restarts
        
        //R1, C0 (wait for ram)
        if(requestIn & ~completeIn) begin
            addr_out <= addr_in;
            wr_mask_out <= wr_mask_in;
            wr_out <= wr_in;
            requestOut <= 1;
            completeOut <= 0;
        end
        
        //R1, C0 (Request) -> (Done) this is ram driven
    
        //R1, C1 (wait for vga)
        if(requestIn & completeIn) begin
            completeOut <= 1;
            requestOut <= 0; //this is rushed so that neither module has to wait for the others logic places ram into sync
        end
        
        //R0, C1 (sync)
        if(~requestIn & completeOut)
            completeOut <= 0; //this is rushed so that neither module has to wait for the others logic places vga into wait for write
        
    end
    
    
endmodule
