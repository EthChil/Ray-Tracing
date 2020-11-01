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
    `ifdef TB
        output reg [11:0]hPix,
    `endif

    //VGA stuff
    output reg [7:0]red, //Drive
    output reg [7:0]green,
    output reg [7:0]blue,
    output wire hSync,
    output wire vSync,
    
    output reg [10:0]vPix,
    input wire pixelClock,
    
    //Memory Interface
//    output reg request_read,
//    input wire read_complete,
    output reg rd_rd_en,
    output reg state_wr_en,

    input wire rd_empty,
    input wire state_full,
    
    output reg VGA_state,
    input wire [127:0]VGA_rd,
    
    //Peripheral lines
    input wire rst,
    output reg [7:0]led
);
    //ui_clk is 81.25mhz
    //
    
    //Pixel buffer holds current group of 5 pixels
    reg [119:0]pixelBuffer;
    
    localparam WAIT = 3'd0;
    localparam REQ_FIRST_BLOCK = 3'd1;
    localparam DRAW = 3'd2;
    localparam HANG = 3'd3;
    localparam REST = 3'd4;
    
    localparam STOP = 2'd0;
    localparam DRAIN = 2'd1;
    localparam START = 2'd2;
    localparam SLEEP = 2'd3;
    
    reg [1:0] sync_state = SLEEP;
    
    `ifndef TB
        reg [11:0] hPix;
    `endif
    
    reg [2:0]startupStateMachine;
    reg [4:0]startupCounter = 0;
        
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
        startupStateMachine = HANG;
        //`endif
        VGA_state = 0;
        rd_rd_en <= 0;
        state_wr_en <= 0;

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
        
        led <= 0;
        
        
//        request_read = 0;
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
    
    //NOTE although the pipeline from ram to the display appears good there may be a timing issue that needs to be remedied
    
    //on every clock the pixels must be driven
    always @(posedge pixelClock) begin
        //C1, R1 Done -> Reset
//        if(read_complete & request_read)
//            request_read <= 0;

        //led <= startupStateMachine;
            
        case(sync_state)
            STOP: begin
                if(~state_wr_en) begin
                    VGA_state <= 0; //STOP
                    state_wr_en <= 1;
                    led <= led + 1;
                end
                else begin
                    state_wr_en <= 0;
                    sync_state <= DRAIN;
                end
            end
            DRAIN: begin
                if(~rd_empty) begin
                    if(~rd_rd_en)
                        rd_rd_en <= 1;
                    else
                        rd_rd_en <= 0;
                end
                else begin
                    sync_state <= START;
                end
            end
            START: begin
                if(~state_wr_en) begin
                    led <= led + 1;
                    VGA_state <= 1; //START
                    state_wr_en <= 1;
                end
                else begin
                    state_wr_en <= 0;
                    sync_state <= SLEEP;
                end
            end
        endcase 
            
        if(startupStateMachine == DRAW & ~rst) begin
//            led[0] <= rd_empty;
//            led[1] <= state_full;
            
            if(sync_state == SLEEP & ~vSync)
                sync_state <= STOP;
                
               
                //Send a request to memory for the next pixel
            `ifdef TB
            if(paintPixel & pixOffset >= 4) begin //this will send a request to the ram for the next pixel*
            `else
            if(paintPixel & pixOffset >= 4 & ~rd_empty) begin
            `endif
                rd_rd_en <= 1;
            
                pixOffset <= 0;
                bitOffset <= 0;
                
                pixelBuffer <= VGA_rd; //load pixel from memory into buffer
//                blue <= 0;
                
//                if(| pixelBuffer)
//                    pixelBuffer <= 0;
//                else
//                    pixelBuffer <= 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
                
                //Reset the offset counter

                
                //Grab address of next group
                
                //Address map
                //0 -> 184320 (
//                if(hPix >= (`hView-5) & vPix >= `vView) //edge case end of frame
//                    VGA_addr <= 0;
//                else
//                    VGA_addr <= VGA_addr + 1;


//                addr_wr_en <= 1;
                    
                //request_read <= 1;
                //Note display was clean when piping from 
                
            end//59 cm 17px in 4cm
            else if(pixOffset >= 4 & paintPixel) fork
//                if(rd_empty)
//                    pixelBuffer <= 0;
                //pixelBuffer <= 128'b1;
//                blue <= 1;
                //led <= 1;
//                VGA_addr <= VGA_addr + 1;
                pixOffset <= 0;
                bitOffset <= 0;
                rd_rd_en <= 0;
//                addr_wr_en <= 0;
            join
            else if(paintPixel) fork
                rd_rd_en <= 0;
//                addr_wr_en <= 0;
                pixOffset <= pixOffset + 1;
                bitOffset <= ((pixOffset +1) * 24);
            join
            
            //5 pixel red (this is reading off the buffer)
            //5 pixel red and green (sometimes 6) (last pixel is blue meaning the read is complete)
            //5 pixel red last pixel is not green or blue
            
            //note: draw vs wait initial value doesn't change anything
            
            //first I think 5 pixels are black (rd not empty)
            //next 5 I think pixels are red rd is empty
            //
            
            //Handle drawing the pixels
            if(paintPixel) fork //this will paint the next pixel
                red <= pixelBuffer >> (bitOffset);
                //red <= rd_empty; //always on
                green <= pixelBuffer >> (bitOffset + 8);
                //green <= read_complete; 
                //blue <= read_complete;
                blue <= pixelBuffer >> (bitOffset + 16); //on then off sometimes
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
        if(rst) fork
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
            startupStateMachine <= HANG;
            
        join
        
        //This will be set at the beginning and after a reset
        //This ensures that the memory is hit and the buffer prepped for the initial frame
        if(startupStateMachine != DRAW & ~rst) begin
            //led <= startupStateMachine;
        
            //When starting up the pixel buffer needs to be filled and a request needs to be sent for the next set
            case(startupStateMachine)
                WAIT: begin
                
                    sync_state <= STOP;
//                    VGA_addr <= 0;
//                    addr_wr_en <= 1;
//                        request_read <= 1;
                    startupStateMachine <= REQ_FIRST_BLOCK;
                end
                REQ_FIRST_BLOCK: begin
                    //led[7] <= rd_empty;
//                    addr_wr_en <= 0;
                    if(sync_state == SLEEP & ~rd_empty) begin
                        rd_rd_en <= 1;
//                        VGA_addr <= VGA_addr + 1;
//                        addr_wr_en <= 1;
//                        request_read <= 1;
                        startupStateMachine <= REST;
                    end
                end
                HANG: begin
                    startupCounter <= startupCounter + 1;
                    if(& startupCounter) begin
                        startupStateMachine <= WAIT;
                    end
                end
                REST: begin
//                    addr_wr_en <= 0;
                    if(rd_rd_en)
                        rd_rd_en <= 0;
                    else begin
                        pixelBuffer <= VGA_rd;
                        startupStateMachine <= DRAW;
                    end
                end
                default:
                    startupStateMachine <= WAIT;
            endcase
        end
    end
endmodule
