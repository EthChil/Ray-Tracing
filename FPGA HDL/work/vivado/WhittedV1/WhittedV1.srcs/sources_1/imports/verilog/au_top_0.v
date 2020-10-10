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

module MemController(
    /* DDR3 Connections */
    inout [15:0]ddr3_dq,
    inout [1:0]ddr3_dqs_n,
    inout [1:0]ddr3_dqs_p,
    
    output [13:0]ddr3_addr,
    output [2:0]ddr3_ba,
    output ddr3_ras_n,
    output ddr3_cas_n,
    output ddr3_we_n,
    output ddr3_reset_n,
    output ddr3_ck_p,
    output ddr3_ck_n,
    output ddr3_cke,
    output ddr3_cs_n,
    output [1:0]ddr3_dm,
    output ddr3_odt,
    
    input reg request_read_vga,
    input reg [27:0]addr_vga,
    output reg [127:0]rd_data_vga,
    
    input reg request_write_rt,
    input reg request_read_rt,
    input reg [127:0] wr_data_rt,
    input reg [15:0] wr_mask_rt,
    input reg [27:0] addr_rt,
    output reg [127:0] rd_data_rt,

    //Default stuff
    input wire clk100,            // 100MHz clock
    input wire clk200,
    input wire clkLock,
    input wire rst,            // reset button (active low)
    output reg [7:0]led
    );
    
    wire sync_rst;
    //initial msg = 8'b01101001;
    
    reg wr_en = 0;

    reg [2:0] cmd = 3'b0;
    reg en = 0;
    
    reg [127:0] wr_data = 128'b1;
    reg [15:0] wr_mask = 0;
    reg [27:0] addr = 28'b0;
    //wire [127:0] rd_data;
    
    wire rd_valid;
    wire rdy;
    wire wr_rdy;
    
    wire ui_clk;
    
//    wire clk200;
//    wire clk100;

    
//    clk_wiz_0 clk_wiz(    
//    .clk_in1(clk),
//    .reset(~rst),
//    .clk_out1(clk100),
//    .clk_out2(clk200),
//    .locked(clkLock)
//    );

    
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
    );

    
    // The reset conditioner is used to synchronize the reset signal to the FPGA
    // clock. This ensures the entire FPGA comes out of reset at the same time.
    //reset_conditioner_1 reset_conditioner(.clk(clk), .in(!rst_n), .out(rst));
    
    //assign led = 8'h00;      // turn LEDs off

    
    
    localparam WRITE_DATA = 3'd0;
    localparam WRITE_CMD = 3'd1;
    localparam READ_CMD = 3'd2;
    localparam READ = 3'd3;
    localparam WAIT_READ = 3'd4;
    localparam DELAY = 3'd5;
    
    reg [2:0]state = WRITE_DATA;

    //Develop robust system to allow memory to be read and written to on request
    //TODO: add reset system
    //TODO: add error code system using leds
    
    initial fork
        request_read_rt = 0;
        request_read_vga = 0;
    join
    
    always @(posedge ui_clk) begin
        case(state)
            WRITE_DATA: begin
                wr_en <= 1;
                wr_mask <= wr_mask_rt;
                wr_data <= wr_data_rt;
                if(wr_rdy)
                    state <= WRITE_CMD;
            end
            WRITE_CMD: begin
                en <= 1;
                cmd <= 0; //0 = write
                addr <= addr_rt; 
                
                if(rdy) begin
                    request_write_rt <= 0;
                    state <= READ_CMD;
                end
            end
            READ_CMD: begin
                en <= 1;
                cmd <= 1; //1 = read
                if(request_read_vga)
                    addr <= addr_vga; 
                else if(request_read_rt)
                    addr <= addr_rt;
                else 
                    addr <= 28'b0;
                
                if(rdy)
                    state <= WAIT_READ;
            end
            WAIT_READ: begin
                if(rd_valid) begin
                    //this will pipe the read data to the correct endpoint
                    if(request_read_vga) begin //VGA gets priority to ensure that the pixels are being driven
                        rd_data_vga <= rd_data;
                        request_read_vga <= 0;
                    end
                    else if(request_read_rt) begin
                        rd_data_rt <= rd_data;
                        request_read_rt <= 0;
                    end
                    
                    state <= DELAY;
                end
                //TODO error handling here
            end
            DELAY: begin
                //This will maximize read cycles which are crucial for 
                if(request_write_rt)
                    state <= WRITE_DATA;
                else
                    state <= READ_CMD;
            end
            default: begin
                state <= WRITE_DATA;
            end
       endcase
    end    
endmodule