////////////////////////////////////////////////////////////////////////////////////
//// Engineer: Ethan Childerhose
//// 
//// Create Date: 10/04/2020 09:42:18 PM
//// Design Name: 
//// Module Name: MemController
//// Project Name: BigCreteGpu
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////

////TODO: add error code system using leds

//module RAM_runner(
//    /* DDR3 Connections */
//    inout [15:0]ddr3_dq,
//    inout [1:0]ddr3_dqs_n,
//    inout [1:0]ddr3_dqs_p,
    
//    output [13:0]ddr3_addr,
//    output [2:0]ddr3_ba,
//    output ddr3_ras_n,
//    output ddr3_cas_n,
//    output ddr3_we_n,
//    output ddr3_reset_n,
//    output ddr3_ck_p,
//    output ddr3_ck_n,
//    output ddr3_cke,
//    output ddr3_cs_n,
//    output [1:0]ddr3_dm,
//    output ddr3_odt,
    
////    input wire request_read_vga,
////    output reg read_complete_vga,
////    input reg [27:0]addr_vga,
////    output reg [127:0]rd_data_vga,
    
////    input wire request_write_rt,
////    output reg write_complete_rt,
////    input wire request_read_rt,
////    output reg read_complete_rt,
    
////    input reg [127:0] wr_data_rt,
////    input reg [15:0] wr_mask_rt,
////    input reg [27:0] addr_wr_rt,
    
////    input reg [27:0] addr_rd_rt,
////    output reg [127:0] rd_data_rt,

//    //Default stuff
//    input wire clk,            // 100MHz clock
////    input wire clk100,
////    input wire clk200,
////    input wire clkLock,
//    input wire rst,            // reset button (active low)
//    output reg [7:0]led
//    );
    
//    wire clk100;
//    wire clk200;
//    wire clkLock;
    
//    clk_wiz_0 clk_wiz(    
//        .clk_in1(clk),
//        .reset(~rst),
//        .clk_out1(clk100),
//        .clk_out2(clk200),
//        .clk_out3(clk173),
//        .locked(clkLock)
//    );
    
//    reg wr_en = 0;

//    reg [2:0] cmd = 3'b0;
//    reg en = 0;
    
//    reg [127:0] wr_data = 1;
//    reg [15:0] wr_mask = 0;
//    reg [27:0] addr = 28'b0;
//    wire [127:0] rd_data;
    
//    wire rd_valid;
//    wire rdy;
//    wire wr_rdy;
    
//    wire ui_clk;

    
//    mig_7series_0 mig(
//    //inouts
//    .app_rd_data(rd_data), 
//    .ddr3_dq(ddr3_dq),
//    .ddr3_dqs_n(ddr3_dqs_n),
//    .ddr3_dqs_p(ddr3_dqs_p),
    
//    //outputs
//    .ddr3_addr(ddr3_addr),
//    .ddr3_ba(ddr3_ba),
//    .ddr3_ras_n(ddr3_ras_n),
//    .ddr3_cas_n(ddr3_cas_n),
//    .ddr3_we_n(ddr3_we_n),
//    .ddr3_reset_n(ddr3_reset_n),
//    .ddr3_ck_p(ddr3_ck_p),
//    .ddr3_ck_n(ddr3_ck_n),
//    .ddr3_cke(ddr3_cke),
//    .ddr3_cs_n(ddr3_cs_n),
//    .ddr3_dm(ddr3_dm),
//    .ddr3_odt(ddr3_odt),
    
//    //User interface
//    .app_sr_req(0),
//    .app_ref_req(0),
//    .app_zq_req(0),
    
//    .app_wdf_data(wr_data),
//    .app_wdf_end(wr_en),
//    .app_wdf_wren(wr_en),
//    .app_wdf_mask(wr_mask),
//    .app_cmd(cmd),
//    .app_en(en),
//    .app_addr(addr),
    
//    //assign rd_data = mig.app_rd_data;
//    .app_rd_data_valid(rd_valid),
//    .app_rdy(rdy),
//    .app_wdf_rdy(wr_rdy),
    
//    .ui_clk(ui_clk),
//    //clocks
//    .sys_clk_i(clk100), //100mhz
//    .clk_ref_i(clk200), //200mhz
//    .sys_rst(~clkLock),
//    .ui_clk_sync_rst(sync_rst)
//    );

    
//    // The reset conditioner is used to synchronize the reset signal to the FPGA
//    // clock. This ensures the entire FPGA comes out of reset at the same time.
//    //reset_conditioner_1 reset_conditioner(.clk(clk), .in(!rst_n), .out(rst));
    
//    //assign led = 8'h00;      // turn LEDs off


//    reg [27:0]addr_ex = 0;
    
//    localparam WRITE_DATA = 3'd0;
//    localparam WRITE_CMD = 3'd1;
//    localparam READ_CMD = 3'd2;
//    localparam READ = 3'd3;
//    localparam WAIT_READ = 3'd4;
//    localparam DELAY = 3'd5;
    
//    reg [2:0]state = DELAY;
    
    
////    initial fork
////        write_complete_rt = 0;
////        read_complete_rt = 0;
        
////        read_complete_vga = 0;
        
////        rd_data_vga = 0;
////    join
    
//    always @(posedge ui_clk) begin
//        if(~rst) fork
////            write_complete_rt <= 0;
////            read_complete_rt <= 0;
            
////            read_complete_vga <= 0;
            
//            state <= DELAY;
//        join
        
////        if(~request_write_rt & write_complete_rt)
////            write_complete_rt <= 0;
////        if(~request_read_vga & read_complete_vga)
////            read_complete_vga <= 0;
////        if(~request_read_rt & read_complete_rt)
////            read_complete_rt <= 0;

//        led <= state;
//        led [7] <= wr_rdy;

//        case(state)
//            WRITE_DATA: begin
//                wr_en <= 1;
                
//                if(wr_rdy)
//                    state <= WRITE_CMD;
//            end
//            WRITE_CMD: begin
//                en <= 1;
//                cmd <= 0; //0 = write
////                addr <= addr_wr_rt << 3; 
//                addr <= addr_ex;
                        
//                wr_mask <= 0;
//                wr_data <= 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
                                
//                if(rdy) begin
//                    if(addr_ex < 255)
//                        addr_ex <= addr_ex + 1;
//                    else
//                        addr_ex <= 0;
////                    write_complete_rt <= 1;
//                    state <= READ_CMD;
//                end
//            end
//            READ_CMD: begin
//                en <= 1;
//                cmd <= 1; //1 = read
                
//                addr <= addr_ex;

//                if(rdy)
//                    state <= WAIT_READ;
//            end
//            WAIT_READ: begin
//                if(rd_valid) begin

////                    if(rd_data == 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
////                        led <= addr_ex;

//                    state <= DELAY;
//                end

//                //TODO error handling here
//            end
//            DELAY: begin

//                state <= WRITE_DATA;
//                #20;
//            end
//            default: begin
//                state <= DELAY;
//            end
//       endcase
//    end    
//endmodule

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ethan Childerhose
// 
// Create Date: 10/04/2020 09:42:18 PM
// Design Name: 
// Module Name: MemController
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

module RAM_runner(
    /* DDR3 Connections */
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
    
    input wire [127:0] wr_data_ext,
    input wire [15:0] wr_mask_ext,
    input wire [27:0] addr_ext,
    output reg [127:0] rd,

    //Default stuff
    input wire clkLock,
    input wire clk200,
    input wire clk100,            // 100MHz clock
    input wire rst,            // reset button (active low)
    output reg [7:0]led,
    
    output reg complete,
    input wire request
    );
    
    wire sync_rst;
    
    reg wr_en = 0;

    reg [2:0] cmd = 0;
    reg en = 0;
    
    reg [127:0] wr_data = 128'b1;
    reg [15:0] wr_mask = 0;
    reg [27:0] addr = 28'b0;
    wire [127:0] rd_data;
    
    wire calib_done;
    
    wire rd_valid;
    wire rdy;
    wire wr_rdy;
    
    //clocked at 
    wire ui_clk;
    
    
    mig_7series_0 mig(
    //inouts
    .app_rd_data(rd_data), 
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
    
    .init_calib_complete(calib_done),
    
    //User interface
    .app_sr_req(0),
    .app_ref_req(0),
    .app_zq_req(0),
    
    .app_wdf_data(wr_data),
    .app_wdf_end(wr_en),
    .app_wdf_wren(wr_en),
    .app_wdf_mask(wr_mask),
    .app_cmd(cmd),
    .app_en(en),
    .app_addr(addr),
    
    //assign rd_data = mig.app_rd_data;
    .app_rd_data_valid(rd_valid),
    .app_rdy(rdy),
    .app_wdf_rdy(wr_rdy),
    
    .ui_clk(ui_clk),
    //clocks
    .sys_clk_i(clk100), //100mhz
    .clk_ref_i(clk200), //200mhz
    .sys_rst(~clkLock),
    .ui_clk_sync_rst(sync_rst)
    ); //34 inputs


    reg [27:0]addr_int = 0;
    reg [7:0]data_int = 0;
    reg [3:0]ctr = 0;
    
    localparam WRITE_DATA = 3'd0;
    localparam WRITE_CMD = 3'd1;
    localparam READ_CMD = 3'd2;
    localparam WAIT_READ = 3'd3;
    localparam DELAY = 3'd4;
    
    reg [2:0]state = WRITE_DATA;
    
    
    always @(posedge ui_clk) begin
        //led <= state;
        //led[0] <= 1;
        
        if(~request & complete)
            complete <= 0;
    
        case(state)
            WRITE_DATA: begin
                wr_en <= 1'b1;
                wr_mask <= 0;
                wr_data <= addr_int;
                //wr_data <= 8'hFF;
                
                if(wr_rdy)
                    state <= WRITE_CMD;
            end
            WRITE_CMD: begin
                en <= 1'b1;
                cmd <= 0; //0 = write
                addr <= {addr_int, 3'b000}; // THIS MIGHT BE WRONG 0s should lead
                
                if(rdy) begin
                    addr_int <= addr_int + 1;
                    state <= WRITE_DATA;
                    if(addr_int == 8'hFF) begin
                        state <= READ_CMD;
                        addr_int <= 0;
                    end
                end
            end
            READ_CMD: begin
                en <= 1'b1;
                cmd <= 1'b1; //1 = read
                if(request)
                    addr <= {addr_ext, 3'b000}; 
                
                if(rdy)
                    state <= WAIT_READ;
            end
            WAIT_READ: begin
                if(rd_valid) begin
//                    led <= rd_data[7:0];
                    
//                    led[5] <= ctr[2];
//                    led[6] <= ctr[3];
                    
                    ctr <= ctr + 1;
                    rd <= rd_data;
                    
                    if(request) begin
                        complete <= 1;
                    end
                    
                    if(~request)
                        state <= DELAY;
                end 
            end
            DELAY: begin
//                ctr <= ctr + 1;
                
//                if(& ctr) begin
//                    ctr <= 0;
//                    state <= READ_CMD;
//                end
                
                if(request & ~complete)
                    state <= READ_CMD;
            end
            default: begin
                state <= WRITE_DATA;
            end
       endcase
    end    
endmodule
