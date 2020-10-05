`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2020 05:49:54 PM
// Design Name: 
// Module Name: top
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

//led1 calibration done led
//led2 pass memory
//led3 fail memory

module top(
    //DDR3 Stuff
    //inouts
    inout [15:0] ddr3_dq,
    inout [1:0] ddr3_dqs_n,
    inout [1:0] ddr3_dqs_p,

    //outputs
    output [13:0] ddr3_addr,
    output[2:0] ddr3_ba,
    output ddr3_ras_n,
    output ddr3_cas_n,
    output ddr3_we_n,
    output ddr3_reset_n,
    output ddr3_ck_p,
    output ddr3_ck_n,
    output ddr3_cke,
    output ddr3_cs_n,
    output [1:0] ddr3_dm,
    output ddr3_odt,
    
    //My stuff
    input wire button,
    output wire led1,
    output reg led2,
    output reg led3,
    input wire clk //100mhz clock
    );
  
    wire calib_done;
    
    reg [27:0] app_addr = 0;
    reg [2:0] app_cmd = 0;
    reg app_en;
    wire app_rdy;
    
    reg  [127:0] app_wdf_data;
    wire app_wdf_end = 1;
    reg  app_wdf_wren;
    wire app_wdf_rdy;
    
    reg [127:0] app_rd_data;
    wire [15:0] app_wdf_mask = 0;
    wire app_rd_data_end;
    wire app_rd_data_valid;
    
    wire app_sr_req = 0;
    wire app_ref_req = 0;
    wire app_zq_req = 0;
    wire app_sr_active;
    wire app_ref_ack;
    wire app_zq_ack;
    
    wire ui_clk;
    wire ui_clk_sync_rst;
    
    wire sys_clk_i;
    
    reg [127:0] data_to_write = {32'hcafebabe, 32'habbaabba,
                                 32'h12345678, 32'hface4321};
    reg [127:0] data_read_from_memory = 128'd0;
    
    // Power-on-reset generator circuit.
    // Asserts resetn for 1023 cycles, then deasserts
    // `resetn` is Active low reset
    reg [9:0] por_counter = 1023;
    always @ (posedge clk) begin
        if (por_counter) begin
            por_counter <= por_counter - 1 ;
        end
    end
    
    wire rst = (por_counter == 0);
    reg trig = 0;
    reg [2:0] counter = 0;


   //Clock tings ahlie fam
   clk_wiz_0 wiz(); 
   //assign wiz.reset = ~button;
   assign wiz.reset = rst;
   assign wiz.clk_in1 = clk; //attach external 100mhz clock
   
   
   //Memory shit
   mig_7series_0 mig();
   assign mig.ddr3_dq = ddr3_dq;
   assign mig.ddr3_dqs_n = ddr3_dqs_n;
   assign mig.ddr3_dqs_p = ddr3_dqs_p;
   assign mig.ddr3_addr = ddr3_addr;
   assign mig.ddr3_ba = ddr3_ba;
   assign mig.ddr3_ras_n = ddr3_ras_n;
   assign mig.ddr3_cas_n = ddr3_cas_n;
   assign mig.ddr3_we_n = ddr3_we_n;
   assign mig.ddr3_reset_n = ddr3_reset_n;
   assign mig.ddr3_ck_p = ddr3_ck_p;
   assign mig.ddr3_ck_n = ddr3_ck_n;
   assign mig.ddr3_cke = ddr3_cke;
   assign mig.ddr3_cs_n = ddr3_cs_n;
   assign mig.ddr3_dm = ddr3_dm;
   assign mig.ddr3_odt = ddr3_odt;
   
   assign mig.init_calib_complete = calib_done;
   
   //User interface ports
   assign mig.app_addr = app_addr;
   assign mig.app_cmd = app_cmd;
   assign mig.app_en = app_en;
   assign mig.app_wdf_data = app_wdf_data;
   assign mig.app_wdf_end = app_wdf_end;
   assign mig.app_wdf_wren = app_wdf_wren;
   assign mig.app_rd_data = app_rd_data;
   assign mig.app_rd_data_end = app_rd_data_end;
   assign mig.app_rd_data_valid = app_rd_data_valid;
   assign mig.app_rdy = app_rdy;
   assign mig.app_wdf_rdy = app_wdf_rdy;
   assign mig.app_sr_req = app_sr_req;
   assign mig.app_ref_req = app_ref_req;
   assign mig.app_zq_req = app_zq_req;
   assign mig.app_sr_active = app_sr_active;
   assign mig.app_ref_ack = app_ref_ack;
   assign mig.app_zq_ack = app_zq_ack;
   assign mig.ui_clk = ui_clk;
   assign mig.ui_clk_sync_rst = ui_clk_sync_rst;
   assign mig.app_wdf_mask = app_wdf_mask;
   
   
   //assign mig.clk_reg = wiz.clk_out2; //200mhz clock
   //assign mig.sys_clk = wiz.clk_out1; //100mhz clock
   assign mig.sys_clk_i = wiz.clk_out2;
   
   //assign mig.sync_rst = rst;
   //assign mig.sys_rst = ~clk_wiz.locked;
   assign mig.sys_rst = rst;
   

//    always @(posedge clk) begin
//        if(button) begin
//            counter <= counter + 1;
//        end
//    end
    
//    assign led[7] = button;


    localparam IDLE = 3'd0;
    localparam WRITE = 3'd1;
    localparam WRITE_DONE = 3'd2;
    localparam READ = 3'd3;
    localparam READ_DONE = 3'd4;
    localparam PARK = 3'd5;
    reg [2:0]state = IDLE;
    
    localparam CMD_WRITE = 3'b000;
    localparam CMD_READ = 3'b001;
    
    assign led1 = calib_done;
    
    always @(posedge ui_clk) begin
        if(ui_clk_sync_rst) begin
            state <= IDLE;
            app_en <= 0;
            app_wdf_wren <= 0;
        end
        else begin
            case (state)
                IDLE: begin
                    if(calib_done) begin
                        state <= WRITE;
                    end
                end
                
                WRITE: begin
                    if(app_rdy & app_wdf_rdy) begin
                        state <= WRITE_DONE;
                        app_en <= 1;
                        app_wdf_wren <= 1;
                        app_addr <= 0;
                        app_cmd <= CMD_WRITE;
                        app_wdf_data <= data_to_write;
                    end
                end
                
                WRITE_DONE: begin
                    if(app_rdy & app_en) begin
                        app_en <= 0;
                    end
                    
                    if(app_wdf_rdy & app_wdf_wren) begin
                        app_wdf_wren <= 0;
                    end
                    
                    if(~app_en & ~app_wdf_wren) begin
                        state <= READ;
                    end
                end
                
                READ: begin
                    if(app_rdy) begin
                        app_en <= 1;
                        app_addr <= 0;
                        app_cmd <= CMD_READ;
                        state <= READ_DONE;
                    end
                end
                
                READ_DONE: begin
                    if(app_rdy & app_en) begin
                        app_en <= 0;
                    end
                    
                    if(app_rd_data_valid) begin
                        data_read_from_memory <= app_rd_data;
                        state <= PARK;
                    end
                end
                
                PARK: begin
                    if(data_to_write == data_read_from_memory) begin
                        led2 <= 1;
                    end 
                    else if(data_to_write == data_read_from_memory) begin
                        led3 <= 0;
                    end
                end
                
                default: state <= IDLE;
             endcase
        end
    end
    

endmodule
