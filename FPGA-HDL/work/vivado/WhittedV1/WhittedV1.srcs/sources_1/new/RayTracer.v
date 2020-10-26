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
    //for ram write arbitartion
    output reg request_write, 
    input wire write_complete,
    
    //for ram read arbitration
    output reg request_read,
    input wire read_complete,
    
    //outputs to write to ram
    output reg [27:0]addr_wr_rt,
    output reg [127:0]wr_data_rt,
    output reg [15:0]wr_mask_rt,

    //outputs to read from ram
    output reg [27:0]addr_rd_rt,
    output reg [127:0]rd_data_rt,
    
    //Current line drawn on VGA
    input reg[10:0] vgaV,
    
    input wire rst,
    input wire clk
    );
    
    //local horizontal pixel and vertical pixel, both should only cover the viewable space    
    reg [10:0]hPix; //max 1920
    reg [10:0]vPix; //
    
    //local offset for 5 pixel memory chunks
    reg [2:0]offset;
    
    reg [119:0]pixel_buffer;
    
    
    initial fork
        request_write = 0;
        request_read = 0;
        
        wr_mask_rt = 0;
        addr_wr_rt = 0;
        addr_rd_rt = 0;
        
        hPix = 0;
        vPix = 0;
        
        offset = 0;
        
        pixel_buffer = 0;
    join

    
    always @(posedge clk) begin
        if(~rst) begin
            request_write <= 0;
            request_read <= 0;
            
            wr_mask_rt <= 0;
            addr_wr_rt <= 0;
            addr_rd_rt <= 0;
            
            hPix <= 0;
            vPix <= 0;
            
            offset <= 0;
            
            pixel_buffer = 0;
        end
    
        //handle the aribter bit resets
        if(write_complete & request_write)
            request_write <= 0;
        if(read_complete & request_read)
            request_read <= 0;

       //TODO: figure out a method by which to sync the pixel for now this should be fine tho
        //pixel_buffer <= pixel_buffer << 12;
        
        if(hPix <= 1000)
            //pixel_buffer <= ((pixel_buffer << 24) | (24'h000000));
            pixel_buffer <=  128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        else
            pixel_buffer <=  0;
            //pixel_buffer <= ((pixel_buffer << 24) | (24'hFFFFFF));
        
        
        offset <= offset + 1;
        
        if(~write_complete & ~request_write & offset == 5) begin
            fork
                offset <= 0;
                addr_wr_rt <= addr_wr_rt + 1;
                //wr_data_rt <= pixel_buffer;
                //wr_data_rt <= 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            join
            
            pixel_buffer <= 0;

            request_write <= 1;
        end
        else if(offset == 5) fork
            offset <= 0;
            addr_wr_rt <= addr_wr_rt + 1;
            pixel_buffer <= 0;
        join


        if(hPix >= `hView & vPix >= `vView) fork
            addr_wr_rt <= 0;
            hPix <= 0;
            vPix <= 0;
        join 
        else if(hPix >= `hView) fork
            hPix <= 0;
            vPix <= vPix + 1;
        join
        else
            hPix <= hPix + 1;
 
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
