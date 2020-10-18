module ram_run_top(    
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

    input wire clk,
    input wire rst,
    output reg [7:0]led,
    input wire usb_rx,           // USB->Serial input
    output wire usb_tx           // USB->Serial output
    );
    
    wire clk200;
    wire clk173;
    wire clk100;
    
    wire complete_t;
    wire clkLock;
    
    reg [127:0] wr_data = 128'h0000000000000069;
    reg [15:0] wr_mask = 16'b0;
    
    reg [27:0] addr_buff = 28'd0;
    wire [127:0] rd_buff;
    
    reg [27:0] addr = 28'b0;
    reg [127:0] rd_data;
    
    reg request_t = 0;
    reg request_r = 0;
    //reg complete_t = 0;
    reg complete_r = 0;
    
    reg [22:0]ctr = 0;
    
    always @(posedge clk173) begin
        if(complete_r & request_t)
            request_t <= 0;
            
        if(~complete_r & ~request_t & {& ctr}) begin
            led <= rd_data[7:0];
            led[7] <= ~led[7];
        
            if(addr == 8'hFF)
                addr <= 0;
            else
                addr <= addr + 1;
            
            request_t <= 1;
        end
        
        ctr <= ctr + 1;
    end
    
    always @(complete_t, request_t) begin
        if(request_t & ~complete_t) begin
            addr_buff <= addr;
            request_r <= 1;
            complete_r <= 0;
        end
        
        if(request_t & complete_t) begin
            rd_data <= rd_buff;
            complete_r <= 1;
            request_r <= 0;
        end
        
        if(~request_t & complete_t)
            complete_r <= 0;

    end
    
    clk_wiz_0 clk_wiz(    
        .clk_in1(clk),
        .reset(~rst),
        .clk_out1(clk100),
        .clk_out2(clk200),
        .clk_out3(clk173),
        .locked(clkLock)
    );
    
    RAM_runner ram(
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
    
    .clkLock(clkLock),
    .clk200(clk200),
    .clk100(clk100),
    .rst(rst),
    .wr_data_ext(wr_data),
    .wr_mask_ext(wr_mask),
    .addr_ext(addr_buff),
    .rd(rd_buff),
    //.led(led),
    
    .complete(complete_t),
    .request(request_r)
    );

    
    assign usb_tx = usb_rx;  // echo the serial data
    
endmodule