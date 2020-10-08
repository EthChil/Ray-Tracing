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
    output reg RT_request_write,
    output reg RT_request_read,
    output reg [127:0]wr_data_rt,
    output reg [15:0]wr_mask_rt,
    output reg [27:0]addr_rt,
    output reg [127:0]rd_data_rt,
    
    //These are the current pixels being drawn on the screen piped in from VGA
    //input reg vgaH,
    input reg vgaV,
    input wire rst
    );
    
    wire paintPixel;
    wire [3:0]offset;
    
    reg [11:0]hPix = 0;
    reg [10:0]vPix = 0;
    assign offset = (hPix%5);
    
    assign paintPixel = (hPix < 1920 & vPix < 1080);
    
    always @(*) begin
        if(vPix < vgaV) begin
            fork
                wr_mask_rt <= (28'b1 & (3'b000 << (offset * 3)));
                wr_data_rt <=  ((hPix % 3 == 0 | vPix % 9 == 0) ? 24'b1 : 24'b0) << (offset * 24);
                
                if(paintPixel)
                     addr_rt <= ((vPix * 385) + (hPix*0.2));
            join
            
            RT_request_write <= 1;
            
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
    
    //The clock for this
    //The clock must be such that a ray is traced faster than pixels are drawn, therefore the minimum clock would be the 
    
    //Actual ray tracer design
    //Steps
    //pixel counter
    //verify that pixel counter is not exceeding the current pixel being drawn
    //take pixel generate ray (to generate the ray two points must be turned into a vector this is 3 float subtractions)
    //
    
endmodule
