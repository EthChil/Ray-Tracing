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
output reg [7:0]red, //Drive
output reg [7:0]green,
output reg [7:0]blue,
output wire hSync,
output wire vSync,

output reg [11:0]hPix,
output reg [10:0]vPix,
input wire pixelClock,

//Memory Interface
output reg request_read,
input wire read_complete,

output reg [27:0]VGA_addr,
input wire [127:0]VGA_rd,

//Peripheral lines
input wire rst
);
    
    //Pixel buffer holds current group of 5 pixels
    reg [119:0]pixelBuffer;
    
    parameter WAIT = 0;
    parameter REQ_FIRST_BLOCK = 1;
    parameter REQ_SECOND_BLOCK = 2;
    parameter DRAW = 3;
    
    
    reg [1:0]startupStateMachine;
    
    //boolean that tracks if we are in a display section of the screen
    wire paintPixel = (hPix <= 1920 & vPix < 1080);
    //pix offset tracks position within 5 pixel group
    reg [3:0]pixOffset;
    
    initial fork
        //Ready to draw begins wait as things need to load up first
        startupStateMachine = WAIT;

        //initially 0 so that they aren't x
        red = 8'b0;
        blue = 8'b0;
        green = 8'b0;
        
        //obviously we will start with the first pixel on the screen
        hPix = 1;
        vPix = 0;
        
        //pixel offset goes from 1 -> 5 
        pixOffset = 1;
        //pixel buffer starts at 0 and will be set once things are called from memory
        pixelBuffer = 0;
        
        request_read = 0;
    join
    
    
    //This handles the hSync and vSync lines
    assign hSync = ~((hPix >= `hSyncStart) & (hPix <= `hSyncEnd));
    assign vSync = ~((vPix >= `vSyncStart) & (vPix <= `vSyncEnd));
    
    
    
    //on every clock the pixels must be driven
    always @(posedge pixelClock) begin
        //request read 
        //TODO: replace 
        
        //C1, R1 Done -> Reset
        if(read_complete & request_read)
            request_read <= 0;
    
        if(startupStateMachine == DRAW) begin
            //Handle drawing the pixels
            if(paintPixel) fork //this will paint the next pixel
                red <= pixelBuffer >> ((pixOffset-1) * 24);
                green <= pixelBuffer >> (((pixOffset-1) * 24) + 8);
                blue <= pixelBuffer >> (((pixOffset-1) * 24) + 16);
            join
            else fork
                red <= 8'b0;
                green <= 8'b0;
                blue <= 8'b0;
            join
            
            //Increment horizontal and vertical counters
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
            
            //increment pix offset
            pixOffset <= pixOffset + 1;
        end
            
        //Send a request to memory for the next pixel
        if(paintPixel & pixOffset >= 5 & ~request_read) begin //this will send a request to the ram for the next pixel*
            pixelBuffer <= VGA_rd[119:0]; //load pixel from memory into buffer
            
            //Reset the offset counter
            pixOffset <= 1;
            
            //Grab address of next group
            if(hPix >= 1915 & vPix >= 1080) //edge case end of frame
                VGA_addr <= 0;
            else
                VGA_addr <= VGA_addr + 1;
                
            //Request next group from memory
            request_read <= 1;
        end

        
        //If the chip is reset the draw should restart
        //This will reset all the crucial values
        if(rst) fork
            //initially 0 so that they aren't x
            red <= 8'b0;
            blue <= 8'b0;
            green <= 8'b0;
            
            //obviously we will start with the first pixel on the screen
            hPix <= 1;
            vPix <= 0;
            
            //pixel offset goes from 1 -> 5 
            pixOffset <= 1;
            //pixel buffer starts at 0 and will be set once things are called from memory
            pixelBuffer <= 0;
            
            //Startup state machine starts at wait while stuff loads
            startupStateMachine <= WAIT;
        join
        
        //This will be set at the beginning and after a reset
        //This ensures that the memory is hit and the buffer prepped for the initial frame
        if(startupStateMachine !== DRAW | ~rst) begin
            //When starting up the pixel buffer needs to be filled and a request needs to be sent for the next set
            case(startupStateMachine)
                WAIT:
                    if(request_read == 0 & read_complete) begin
                        VGA_addr <= 0;
                        request_read <= 1;
                        startupStateMachine <= REQ_FIRST_BLOCK;
                    end
                REQ_FIRST_BLOCK: begin
                    if(request_read == 0 & read_complete) begin
                        VGA_addr <= VGA_addr + 1;
                        pixelBuffer <= VGA_rd[119:0];
                        request_read <= 1;
                        startupStateMachine <= DRAW;
                    end
                end
                default:
                    startupStateMachine <= WAIT;
            endcase
        end
    end
endmodule
