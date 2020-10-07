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

//1920 x 1080 specs
//pixel clock 173Mhz
//horizontal
//front porch .74us 128px
//sync 1.156us 200px
//back porch 1.896us 328px
//
//vertical
//front porch 44.671us 3 lines (7728px)
//sync 74.451us 5 lines (12880px)
//back porch 476.486us 32 lines (82432px)

//VGA constants
`define hFrontPorch 128 //pix
`define hSync 200 //pix
`define hBackPorch 328 //pix
`define hLength 2576

`define vFrontPorch 3 //lines
`define vSync 5 //lines
`define vBackPorch 32 //lines
`define vLength 1120

//1920 x 1080 = 49,766,400px
//each pixel is 24bits (8bit x 3colours)
//this results in 5.3 pixels per row of memory, to make it easy we will do 3
//this results in us using one row per pixel 

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

input refClk,
input rst
);

    wire paintPixel;
    reg nextLineReady = 0;
    
    assign paintPixel = (hPix < 1920 & vPix < 1080);
    
    clk_wiz_1 clk(.clk_in1(refClk), .clk_out1(pixelClock), .reset(~rst));
    
    //This handles the hSync and vSync lines
    assign hSync = ((hPix > (`hLength - `hBackPorch)) | (hPix < (`hLength - (`hBackPorch + `hSync))));
    assign vSync = ((vPix > (`vLength - `vBackPorch)) | (vPix < (`vLength - (`vBackPorch + `vSync))));
    
    
    always @(posedge pixelClock) begin
        //Incrememnt the pixel positions
        if(hPix >= `hLength & vPix >= `vLength) begin
            hPix <= 0;
            vPix <= 0;
        end 
        else if(hPix >= `hLength) begin
            hPix <= 1;
            vPix <= vPix + 1;
        end
        else begin
            hPix <= hPix + 1;
        end
        
        //Handle drawing the pixels
        if(VGA_request_read !== 0 & paintPixel) //this verifies that we have recieved the next pixel
            $finish;
        else if(paintPixel) begin //this will paint the next pixel
            red <= VGA_rd[7:0];
            green <= VGA_rd[15:8];
            blue <= VGA_rd[23:16];
        end
        
        //Send a request to memory for the next pixel
        if(paintPixel) begin //this will send a request to the ram for the next pixel
            VGA_addr <= (vPix * 1920) + hPix;
            VGA_request_read <= 1;
        end
        else if(~nextLineReady) begin //this pretty much will prep the upcoming pixel while in the porch
            VGA_addr <= ((vPix+1) * 1920) + 1;
            VGA_request_read <= 1;
            nextLineReady <= 1;
        end    
        
        //If the chip is reset the draw should restart
        if(rst) begin
            hPix <= 0;
            vPix <= 0;
        end
    end
endmodule
