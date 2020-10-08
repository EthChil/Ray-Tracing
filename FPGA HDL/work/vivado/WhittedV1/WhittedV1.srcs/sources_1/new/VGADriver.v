//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ethan Childerhose
// 
// Create Date: 10/04/2020 09:42:18 PM
// Design Name: 
// Module Name: VGADriver
// Project Name: BigCreteGpu
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

//(1920 x 1080) x 24bit colour = 49,766,400bit
//each pixel is 24bits (8bit x 3colours)
//this results in 5.3 pixels per row of memory, to make it easy we will do 5
//this results in us placing 5 pixels in every row where a pixel is a block of 24bits 
//TODO change code from one row per pixel to one row per five pixels

module VGADriver(
//VGA stuff
output reg [7:0]red,
output reg [7:0]green,
output reg [7:0]blue,
output wire hSync,
output wire vSync,

output reg [11:0]hPix,
output reg [10:0]vPix,
output wire pixelClock,

//Memory Interface
output reg VGA_request_read,
output reg [27:0]VGA_addr,
input wire [127:0]VGA_rd,

//Peripheral lines
output reg readyToDraw,
input wire refClk,
input wire rst
);
    
    reg [119:0]pixelBuffer = 0;
    wire paintPixel;
    wire [3:0]pixOffset;
    
    
    assign pixOffset = (hPix%5);
    assign paintPixel = (hPix < 1920 & vPix < 1080);
    
    clk_wiz_1 clk(.clk_in1(refClk), .clk_out1(pixelClock), .reset(~rst));
    
    //This handles the hSync and vSync lines
    assign hSync = ((hPix > (`hLength - `hBackPorch)) | (hPix < (`hLength - (`hBackPorch + `hSync))));
    assign vSync = ((vPix > (`vLength - `vBackPorch)) | (vPix < (`vLength - (`vBackPorch + `vSync))));
    
    //TODO add pixel prep that will populate buffers
    
    always @(posedge pixelClock) begin
        //Incrememnt the pixel positions
        if(readyToDraw) begin
            if(hPix >= `hLength & vPix >= `vLength) fork
                hPix <= 1;
                vPix <= 0;
            join 
            else if(hPix >= `hLength) fork
                hPix <= 1;
                vPix <= vPix + 1;
            join
            else
                hPix <= hPix + 1;
        
            //Handle drawing the pixels
            if(paintPixel) fork //this will paint the next pixel
                red <= pixelBuffer >> (pixOffset * 24);
                green <= pixelBuffer >> ((pixOffset * 24) + 8);
                blue <= pixelBuffer >> ((pixOffset * 24) + 16);
            join
            
            //Send a request to memory for the next pixel
            if(paintPixel & hPix%5 == 0 & VGA_request_read == 0) begin //this will send a request to the ram for the next pixel*
                pixelBuffer <= VGA_rd[119:0]; //load pixel from memory into buffer
                
                //Grab address of next group
                if(hPix >= 1915 & vPix >= 1080) //edge case end of frame
                    VGA_addr <= 0;
                else if(hPix >= 1915) //edge case end of line
                    VGA_addr <= ((vPix+1) * 385);
                else
                    VGA_addr <= (vPix * 385) + (hPix*0.2) + 1;
                    
                //Request next group from memory
                VGA_request_read <= 1;
            end
        end
        
        //If the chip is reset the draw should restart
        //This will reset all the crucial values
        if(rst) fork
            hPix <= 1;
            vPix <= 0;
            readyToDraw <= 0;
        join
        
        //This will be set at the beginning and after a reset
        //This ensures that the memory is hit and the buffer prepped for the initial frame
        if(~readyToDraw & ~rst) begin
            hPix <= 1;
            vPix <= 0;
        
            if(VGA_request_read == 0) fork
                VGA_addr <= 0;
                VGA_request_read = 1;
                readyToDraw <= 1;
            join
        end
    end
endmodule
