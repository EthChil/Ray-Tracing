module au_top_0(
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

    //Default stuff
    input clk,              // 100MHz clock
    input rst_n,            // reset button (active low)
    output reg [7:0] led,       // 8 user controllable LEDs
    input usb_rx,           // USB->Serial input
    output usb_tx           // USB->Serial output
    );
    
    wire rst;
    
    reg [7:0] msg = 8'b01101001;
    
    reg [127:0] wr_data = 128'bx;
    reg wr_en = 0;
    //wire wr_en = 0;
    reg [15:0] wr_mask = 0;
    reg [2:0] cmd = 3'bx;
    reg en = 0;
    reg [27:0] addr = 28'bx;
    
    wire [127:0] rd_data;
    wire rd_valid;
    wire rdy;
    wire wr_rdy;
    
    clk_wiz_0 clk_wiz();
    assign clk_wiz.clk_in1 = clk;
    assign clk_wiz.reset = ~rst;
    
    mig_7series_0 mig();
    //inouts
    assign mig.ddr3_dq = ddr3_dq;
    assign mig.ddr3_dqs_n = ddr3_dqs_n;
    assign mig.ddr3_dqs_p = ddr3_dqs_p;
    
    //outputs
    assign ddr3_addr = mig.ddr3_addr;
    assign ddr3_ba = mig.ddr3_ba;
    assign ddr3_ras_n = mig.ddr3_ras_n;
    assign ddr3_cas_n = mig.ddr3_cas_n;
    assign ddr3_we_n = mig.ddr3_we_n;
    assign ddr3_reset_n = mig.ddr3_reset_n;
    assign ddr3_ck_p = mig.ddr3_ck_p;
    assign ddr3_ck_n = mig.ddr3_ck_n;
    assign ddr3_cke = mig.ddr3_cke;
    assign ddr3_cs_n = mig.ddr3_cs_n;
    assign ddr3_dm = mig.ddr3_dm;
    assign ddr3_odt = mig.ddr3_odt;
    
    //User interface
    assign mig.app_sr_req = 0;
    assign mig.app_ref_req = 0;
    assign mig.app_zq_req = 0;
    
    assign mig.app_wdf_data = wr_data;
    assign mig.app_wdf_end = wr_en;
    assign mig.app_wdf_wren = wr_en;
    assign mig.app_wdf_mask = wr_mask;
    assign mig.app_cmd = cmd;
    assign mig.app_en = en;
    assign mig.app_addr = addr;
     
    assign rd_data = mig.app_rd_data;
    assign rd_valid = mig.app_rd_data_valid;
    assign rdy = mig.app_rdy;
    assign wr_rdy = mig.app_wdf_rdy;
     
    wire ui_clk;
    assign ui_clk = mig.ui_clk;
    
    //clocks
    assign mig.sys_clk_i = clk_wiz.clk_out1; //100mhz
    assign mig.clk_ref_i = clk_wiz.clk_out2;
    assign mig.sys_rst = ~clk_wiz.locked;
    assign rst = mig.ui_clk_sync_rst;
    
    // The reset conditioner is used to synchronize the reset signal to the FPGA
    // clock. This ensures the entire FPGA comes out of reset at the same time.
    reset_conditioner_1 reset_conditioner(.clk(clk), .in(!rst_n), .out(rst));
    
    //assign led = 8'h00;      // turn LEDs off

    assign usb_tx = usb_rx;  // echo the serial data
    
    localparam WRITE_DATA = 3'd0;
    localparam WRITE_CMD = 3'd1;
    localparam READ_CMD = 3'd2;
    localparam READ = 3'd3;
    localparam WAIT_READ = 3'd4;
    localparam DELAY = 3'd5;
    
    reg [2:0]state = WRITE_DATA;
    
    always @(posedge clk) begin
        case(state)
            WRITE_DATA: begin
                wr_en <= 1;
                wr_data <= msg;
                
                if(wr_rdy)
                    state <= WRITE_CMD;
            end
            WRITE_CMD: begin
                en <= 1;
                cmd <= 0; //0 = write
                addr <= (msg >> 3); // THIS MIGHT BE WRONG 0s should lead
                
                if(rdy) begin
                    state <= READ_CMD;
                end
            end
            READ_CMD: begin
                en <= 1;
                cmd <= 1; //1 = read
                addr <= (msg >> 3); 
                if(rdy)
                    state <= WAIT_READ;
            end
            WAIT_READ: begin
                if(rd_valid) begin
                    led <= rd_data;
                    state <= DELAY;
                end 
            end
            DELAY: begin
                state <= READ_CMD;
            end
        endcase
    end    
endmodule