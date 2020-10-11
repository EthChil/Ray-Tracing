//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2020 09:42:18 PM
// Design Name: 
// Module Name: RayTracer
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

`include "display_specs.vh"

module RayTracer(
    output reg request_write, 
    input wire write_complete, //conditioned outside
    output reg request_read, //conditioned outside
    input wire read_complete, //conditioned outside
    
    output reg [127:0]wr_data_rt,
    output reg [15:0]wr_mask_rt,
    output reg [27:0]addr_rt,
    output reg [127:0]rd_data_rt,
    
    //These are the current pixels being drawn on the screen piped in from VGA
    //input reg vgaH,
    input reg[10:0] vgaV,
    output reg ready,
    
    input wire rst,
    input wire clk
    );
    
    wire paintPixel = (hPix < 1920 & vPix < 1080);
    reg [3:0]offset;
    
    reg [11:0]hPix;
    reg [10:0]vPix;
    
    reg vertVGA;
    
    initial fork
        request_write = 0;
        request_read = 0;
        
        wr_mask_rt = 0;
        addr_rt = 0;
        
        hPix = 0;
        vPix = 0;
        
        offset = 1;
        vertVGA = 0;
    join
    

    
    always @(posedge clk) begin
    
        if(rst) fork
            request_write <= 0;
            request_read <= 0;
            
            wr_mask_rt <= 0;
            addr_rt <= 0;
            
            hPix <= 0;
            vPix <= 0;
            
            offset <= 1;
            vertVGA <= 0;
        join
    
        if(write_complete & request_write)
            request_write <= 0;
        if(read_complete & request_write)
            request_write <= 0;
        ready <= 0;
        vertVGA <= vgaV;
        ready <= 1;

    
        if(vPix < vertVGA) begin
            offset <= offset + 1;
            
            if(write_complete) begin
                fork
                    wr_mask_rt <= (28'b1 & (3'b000 << (offset * 3)));
                    wr_data_rt <=  ((hPix < 500 & vPix < 500) ? 24'b1 : 24'b0) << (offset * 24);
                    
                    if(paintPixel & offset >= 5) fork
                         offset <= 1;
                         addr_rt <= addr_rt + 1;
                    join
                join
                
                request_write <= 1;
    
                if(hPix >= `hLength & vPix >= `vLength) fork
                    hPix <= 0;
                    vPix <= 0;
                join 
                else if(hPix >= `hLength) fork
                    hPix <= 1;
                    vPix <= vPix + 1;
                join
                else
                    hPix <= hPix + 1;
             end

        end
    end
    
    //The clock for this (temporarily using 200mhz clock which should allow it to run faster than vga)
    //The clock must be such that a ray is traced faster than pixels are drawn, therefore the minimum clock would be the 
    
    //Actual ray tracer design
    //Steps
    //pixel counter
    //verify that pixel counter is not exceeding the current pixel being drawn
    //take pixel generate ray (to generate the ray two points must be turned into a vector this is 3 float subtractions)
    //
    
endmodule
