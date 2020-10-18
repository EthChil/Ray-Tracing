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


//`define noRam 1'b1
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
    //ui_clk is 81.25mhz
    //
    
    //Pixel buffer holds current group of 5 pixels
    reg [119:0]pixelBuffer;
    
    parameter WAIT = 2'd0;
    parameter REQ_FIRST_BLOCK = 2'd1;
    parameter REQ_SECOND_BLOCK = 2'd2;
    parameter DRAW = 2'd3;
    
    reg [11:0] hPix;
    
    reg [1:0]startupStateMachine;
    
    //boolean that tracks if we are in a display section of the screen
    wire paintPixel = (hPix <= `hView & vPix < `vView);
    //pix offset tracks position within 5 pixel group
    reg [2:0]pixOffset;
    
    reg [6:0]bitOffset;
    
    
    initial fork
        //Ready to draw begins wait as things need to load up first
        //`ifdef noRam
        //startupStateMachine = DRAW;
        //`else
        startupStateMachine = WAIT;
        //`endif
        VGA_addr = 0;

        //initially 0 so that they aren't x
        red = 8'b0;
        blue = 8'b0;
        green = 8'b0;
        
        //obviously we will start with the first pixel on the screen
        hPix = 1;
        vPix = 0;
        
        //pixel offset goes from 1 -> 5 
        bitOffset = 0;
        pixOffset = 0;
        //pixel buffer starts at 0 and will be set once things are called from memory
        pixelBuffer = 0;
        
        request_read = 0;
        
    join
    
    
    //This handles the hSync and vSync lines
    assign hSync = ~((hPix >= `hSyncStart) & (hPix <= `hSyncEnd));
    assign vSync = ~((vPix >= `vSyncStart) & (vPix <= `vSyncEnd));
    
    //NOTE on the ram vga states
    //R0,C0 <- Rest (waiting on vga to send request)
    //R1,C0 <- request (waiting on ram to fulfil request)
    //R1,C1 <- Done (request filled waiting on vga to accept)
    //R0,C1 <- Reset (vga into rest waiting on ram to follow)
    
    //loop      1   2   3   4   5   6   7
    //pix off   1   2   3   4   1   0   1
    //bit-off   1   2   3   4   1   2   3
    //drawn     1   2   3   4   1   2   3
    //
    
    //on every clock the pixels must be driven
    always @(posedge pixelClock) begin
        //C1, R1 Done -> Reset
        if(read_complete & request_read)
            request_read <= 0;
            
        if(startupStateMachine == DRAW) begin
                //Send a request to memory for the next pixel
            if(paintPixel & pixOffset >= 4 & ~request_read & ~read_complete) begin //this will send a request to the ram for the next pixel*
                pixelBuffer <= VGA_rd; //load pixel from memory into buffer
                
                //Reset the offset counter
                pixOffset <= 0;
                bitOffset <= 0;
                
                //Grab address of next group
                if(hPix >= (`hView-5) & vPix >= `vView) //edge case end of frame
                    VGA_addr <= 0;
                else
                    VGA_addr <= VGA_addr + 1;
                    
                request_read <= 1;
                
            end
            else if(pixOffset >= 4 & paintPixel) fork
                pixOffset <= 0;
                bitOffset <= 0;
            join
            else if(paintPixel) fork
                pixOffset <= pixOffset + 1;
                bitOffset <= ((pixOffset +1) * 24);
            join

            
            //Handle drawing the pixels
            if(paintPixel) fork //this will paint the next pixel
                red <= pixelBuffer >> (bitOffset);
                //red <= request_read;
                green <= pixelBuffer >> (bitOffset + 8);
                //green <= (pixOffset >= 4 ? 1 : 0);
                //blue <= read_complete;
                blue <= pixelBuffer >> (bitOffset + 16);
            join
            else begin
                red <= 0;
                green <= 0;
                blue <= 0;
            end
            
            //Increment horizontal and vertical counters
            if(hPix >= `hLength & vPix >= `vLength) begin
                hPix <= 0;
                vPix <= 0;
            end
            else if(hPix >= `hLength) fork
                vPix <= vPix + 1;
                hPix <= 0;
                pixOffset <= 0;
            join
            else
                hPix <= hPix + 1;

            
        end
            


        
        //If the chip is reset the draw should restart
        //This will reset all the crucial values
        if(~rst) fork
            //initially 0 so that they aren't x
            red <= 8'b0;
            blue <= 8'b0;
            green <= 8'b0;
            
            //obviously we will start with the first pixel on the screen
            hPix <= 1'b1;
            vPix <= 0;
            
            //pixel offset goes from 1 -> 5 
            pixOffset <= 1'b1;
            //pixel buffer starts at 0 and will be set once things are called from memory
            pixelBuffer <= 0;
            
            //Startup state machine starts at wait while stuff loads
            startupStateMachine <= WAIT;
            
            request_read <= 0;
        join
        
        //This will be set at the beginning and after a reset
        //This ensures that the memory is hit and the buffer prepped for the initial frame
        if(startupStateMachine != DRAW | ~rst) begin
        
            //When starting up the pixel buffer needs to be filled and a request needs to be sent for the next set
            case(startupStateMachine)
                WAIT:
                    if(~request_read & ~read_complete) begin
                        VGA_addr <= 0;
                        request_read <= 1;
                        startupStateMachine <= REQ_FIRST_BLOCK;
                    end
                REQ_FIRST_BLOCK: begin
                    if(~request_read & ~read_complete) begin
                        VGA_addr <= VGA_addr + 1;
                        pixelBuffer <= VGA_rd;
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
