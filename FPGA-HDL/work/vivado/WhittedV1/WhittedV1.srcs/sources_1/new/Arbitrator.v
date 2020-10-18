`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: Big Crete Technologies
// Engineer: Ethan Childerhose
// 
// Create Date: 10/10/2020 04:24:02 PM
// Design Name: 
// Module Name: Arbitrator
// Project Name: Big Crete GPU
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


module arbitrator_ram_rd (
    input wire [27:0] addr,
    output reg [27:0] addr_out,
    input wire [127:0] rd,
    output reg [127:0] rd_out, 

    input wire requestIn, //from module
    output reg requestOut, //To RAM
    
    input wire completeIn, //from RAM
    output reg completeOut //To module
    
//    input wire clk_vga,
//    input wire clk_ram
    
    //input wire rst
    );
    
    initial begin
        rd_out = 0;
        addr_out = 0;
        
        requestOut = 0;
        completeOut = 0;
    end
    
    //| vga |   ram    |    ram    |    vga     |      vga    |     ram      |
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
    
    
    
    //Items
    //requestIn
    //completeOut
    //addr_in
    //rd_out
    always @(completeIn, requestIn) begin
//        if(~rst) fork
//            rd_out <= 0;
//            addr_out <= 0;
        
//            requestOut <= 0;
//            completeOut <= 0;
//        join
        
        //R1, C0 (wait for ram)
        if(requestIn & ~completeIn) fork
            addr_out <= addr;
            requestOut <= 1;
            completeOut <= 0;
        join
        
        //R1, C0 (Request) -> (Done) this is ram driven
    
        //R1, C1 (wait for vga)
        if(requestIn & completeIn) begin
            rd_out <= rd;
            completeOut <= 1;
            requestOut <= 0; //this is rushed so that neither module has to wait for the others logic places ram into sync
        end
        
        //R0, C1 (sync)
        if(~requestIn & completeOut)
            completeOut <= 0; //this is rushed so that neither module has to wait for the others logic places vga into wait for write
        
    end
    
    //Items
    //rd_in
    //completeIn
    //requestOut
    //addr_out
    //(* ASYNC_REG = "TRUE" *) reg complete_mid;
    
    
endmodule
