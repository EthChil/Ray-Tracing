//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ethan Childerhose
// 
// Create Date: 10/04/2020 09:42:18 PM
// Design Name: 
// Module Name: Top
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

//GENERAL NOTES
//TODO go back and used a unify naming scheme
//Note possible bug when

//Current config
//Clocks
//100mhz input
//200mhz output -> ram
//
//81.25mhz ui_clk from ram
//60.5mhz (display 720p @ 50hz)



module Top(    
    //DDR3 passthroughs
    inout wire [15:0]ddr3_dq,
    inout wire [1:0]ddr3_dqs_n,
    inout wire [1:0]ddr3_dqs_p,
    
    output wire [13:0]ddr3_addr,
    output wire [2:0]ddr3_ba,
    output wire ddr3_ras_n,
    output wire ddr3_cas_n,
    output wire ddr3_we_n,
    output wire ddr3_reset_n,
    output wire ddr3_ck_p,
    output wire ddr3_ck_n,
    output wire ddr3_cke,
    output wire ddr3_cs_n,
    output wire [1:0]ddr3_dm,
    output wire ddr3_odt,

    //VGA Outputs
    output wire hSync,
    output wire vSync,
    output reg red,
    output reg blue,
    output reg green,

    //Peripherals
    input wire clk,
    //input wire rst,
    output reg [7:0]led,
    input wire usb_rx,           // USB->Serial input
    output wire usb_tx           // USB->Serial output
    );
    
    reg rst = 1;
    reg [3:0]ctr = 4'd10;
    
    reg [7:0]red8;
    reg [7:0]green8;
    reg [7:0]blue8;
    
    wire [1:0]db;
    
    assign red = (| red8);
    assign green = (| green8);
    assign blue = (| blue8);
    //assign green = db[0];
    //assign blue = db[1];
    
    wire pxClk;
    
    wire clk100;
    wire clk200;
    wire clk141;
    wire clkLock;
    wire ram_clk;
    
//    always @(posedge clk) begin
//        ctr <= ctr + 1;
//        if(& ctr)
//            rst <= 0;
//    end
    

    
    //VGA to RT arbitration
    wire [10:0]vPix;
    
    //RAM to VGA arbitration read
    //addr FIFO
    wire [27:0]addr_vga_a;
    wire [27:0]addr_vga_b;
    
    wire [127:0]rd_data_vga_a;
    wire [127:0]rd_data_vga_b;
    
    wire vga_rd_full;
    wire vga_rd_empty;
    
    wire vga_addr_full;
    wire vga_addr_empty;
    
    wire vga_rd_rd_en;
    wire vga_rd_wr_en;
    
    wire vga_addr_rd_en;
    wire vga_addr_wr_en;
    
    always @(posedge clk) begin
        if(~vga_addr_rd_en & ~vga_addr_wr_en & ~vga_rd_rd_en & ~vga_rd_wr_en & rst & ctr )//have it hold reset then drop it low then hold it high then drop it low and hold it there permenantly
        if(~vga_addr_rd_en & ~vga_addr_wr_en & ~vga_rd_rd_en & ~vga_rd_wr_en & ~rst & ctr < 4'd11) begin
            ctr <= ctr - 1;
            if(ctr == 0) begin
                rst <= 1;
                ctr <= 0;
            end
        end
        if(rst) begin
            led <= 0;
            ctr <= ctr + 1;
            if(& ctr) begin
                led <= 1;
                rst <= 0;
                ctr <= 4'b1111;
            end
        end
    end
    
//    wire request_read_vga_out;
//    wire request_read_vga_in;
    
//    wire read_complete_vga_out;
//    wire read_complete_vga_in;
    
    //RAM to RT arbitration read
    wire [27:0]addr_rd_rt_a;
    wire [27:0]addr_rd_rt_b;
    
    wire [127:0]rd_data_rt_a;
    wire [127:0]rd_data_rt_b;
    
    wire request_read_rt_out;
    wire request_read_rt_in;
    
    wire read_complete_rt_out;
    wire read_complete_rt_in;
    
    //RAM to RT arbitration write
    wire [27:0]addr_wr_rt_a;
    wire [27:0]addr_wr_rt_b;
        
    wire [15:0]wr_mask_rt_a;
    wire [15:0]wr_mask_rt_b;
        
    wire [127:0]wr_data_rt_a;
    wire [127:0]wr_data_rt_b;
    
    wire request_write_rt_out;
    wire request_write_rt_in;
        
    wire write_complete_rt_out;
    wire write_complete_rt_in;
    
    fifo_generator_0 fifo_ram_rd (
        //ram side
        .full(vga_rd_full),
        .din(rd_data_vga_a),
        .wr_en(vga_rd_wr_en),
        
        //vga side
        .empty(vga_rd_empty),
        .dout(rd_data_vga_b),
        .rd_en(vga_rd_rd_en),
        
        //Top interface
        .rst(rst),
        .wr_clk(ram_clk), //ram side 81.25mhz
        .rd_clk(clk141) //vga side 60.5mhz
    );

    fifo_generator_1 fifo_ram_addr (
        //vga interfaces
        .full(vga_addr_full),
        .din(addr_vga_a),
        .wr_en(vga_addr_wr_en),
        
        //ram interfaces
        .empty(vga_addr_empty),
        .dout(addr_vga_b),
        .rd_en(vga_addr_rd_en),
        
        //Top interfaces
        .rst(rst),
        .wr_clk(clk141), //vga side 60.5mhz
        .rd_clk(ram_clk) //ram side 81.25mhz
    );
//    arbitrator_ram_rd arb_ram2vga (
//        .addr(addr_vga_a),
//        .addr_out(addr_vga_b),
        
//        .rd(rd_data_vga_a),
//        .rd_out(rd_data_vga_b),
           
//        .requestIn(request_read_vga_out),
//        .requestOut(request_read_vga_in),
        
//        .completeIn(read_complete_vga_out),
//        .completeOut(read_complete_vga_in)
//        //.rst(rst)
//    );
    
    arbitrator_ram_rd arb_ram2rt (
        .addr(addr_rd_rt_a),
        .addr_out(addr_rd_rt_b),
        
        .rd(rd_data_rt_a),
        .rd_out(rd_data_rt_b),
           
        .requestIn(request_read_rt_out),
        .requestOut(request_read_rt_in),
        
        .completeIn(read_complete_rt_out),
        .completeOut(read_complete_rt_in)
        //.rst(rst)
    );
    
    ram_write_arbitrator arb_rt2ram (
        .addr_in(addr_wr_rt_a),
        .addr_out(addr_wr_rt_b),
        
        .wr_mask_in(wr_mask_rt_a),
        .wr_mask_out(wr_mask_rt_b),
        
        .wr_in(wr_data_rt_a),
        .wr_out(wr_data_rt_b),
    
        .requestIn(request_write_rt_out),
        .requestOut(request_write_rt_in),
        
        .completeIn(write_complete_rt_out),
        .completeOut(write_complete_rt_in)
        //.rst(rst)
    );
    

    clk_wiz_0 clk_wiz(    
        .clk_in1(clk),
        .reset(rst),
        .clk_out1(clk100),
        .clk_out2(clk200),
        .clk_out3(clk141),//actually 142.87125
        .locked(clkLock)
    );
    
    
    VGADriver vga(
        //8Bit colour output
        .red(red8), 
        .green(green8),
        .blue(blue8),
        
        //Display sync lines 
        .hSync(hSync),
        .vSync(vSync),
        
        //Next driven pixel
        .vPix(vPix),
        
        //Pixel clock every pulse it will march onto the next pixel
        .pixelClock(clk141),
        
        //Memory interface
//        .request_read(request_read_vga_out),
//        .read_complete(read_complete_vga_in),
        .rd_empty(vga_rd_empty),
        .addr_full(vga_addr_full),
        
        .rd_rd_en(vga_rd_rd_en),
        .addr_wr_en(vga_addr_wr_en),
        
        .VGA_addr(addr_vga_a),
        .VGA_rd(rd_data_vga_b),

        //Peripherals
        .rst(rst)
        //.led(led)
    );

    
    RayTracer RT(
        .request_write(request_write_rt_out),
        .write_complete(write_complete_rt_in),
        .request_read(request_read_rt_out),
        .read_complete(read_complete_rt_in),
        
        .wr_data_rt(wr_data_rt_a),
        .wr_mask_rt(wr_mask_rt_a),
        .addr_wr_rt(addr_wr_rt_a),
        
        .addr_rd_rt(addr_rd_rt_a),
        .rd_data_rt(rd_data_rt_b),
        
        .vgaV(vPix),
        .rst(rst),
        .clk(clk141)
    );
    
    MemController ram(
    //Peripherals
    .ui_clk(ram_clk),
    .clkLock(clkLock),
    .clk100(clk100),
    .clk200(clk200),
    .rst(rst),
//    .led(led),
    
    //inouts
    .ddr3_dq(ddr3_dq),
    .ddr3_dqs_n(ddr3_dqs_n),
    .ddr3_dqs_p(ddr3_dqs_p),
    
    //outputs
    .ddr3_addr(ddr3_addr),
    .ddr3_ba(ddr3_ba),
    .ddr3_ras_n(ddr3_ras_n),
    .ddr3_cas_n(ddr3_cas_n),
    .ddr3_we_n(ddr3_we_n),
    .ddr3_reset_n(ddr3_reset_n),
    .ddr3_ck_p(ddr3_ck_p),
    .ddr3_ck_n(ddr3_ck_n),
    .ddr3_cke(ddr3_cke),
    .ddr3_cs_n(ddr3_cs_n),
    .ddr3_dm(ddr3_dm),
    .ddr3_odt(ddr3_odt),
    
    //Memory connection VGA
//    .request_read_vga(request_read_vga_in),
//    .read_complete_vga(read_complete_vga_out),
    .vga_rd_wr_en(vga_rd_wr_en),
    .vga_addr_rd_en(vga_addr_rd_en),

    .vga_rd_full(vga_rd_full),
    .vga_addr_empty(vga_addr_empty),
    
    .addr_vga(addr_vga_b),
    .rd_data_vga(rd_data_vga_a),
    
    //Memory connection ray tracing core
    .request_write_rt(request_write_rt_in),
    .write_complete_rt(write_complete_rt_out),
    .request_read_rt(request_read_rt_in),
    .read_complete_rt(read_complete_rt_out),
    
    .wr_data_rt(wr_data_rt_b),
    .wr_mask_rt(wr_mask_rt_b),
    .addr_wr_rt(addr_wr_rt_b),
    
    .addr_rd_rt(addr_rd_rt_b),
    .rd_data_rt(rd_data_rt_a),
    .db(db)
    );
    
    assign usb_tx = usb_rx;  // echo the serial data
    
    //assign led = rd_data[7:0];
endmodule
