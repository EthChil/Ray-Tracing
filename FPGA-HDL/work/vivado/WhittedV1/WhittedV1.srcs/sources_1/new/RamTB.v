`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2020 09:46:30 PM
// Design Name: 
// Module Name: RamTB
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


module RamTB();
    
    reg clk = 0;
    


    initial begin
        
    end

    clk_wiz_0 clk_wiz(    
        .clk_in1(clk),
        .reset(~rst),
        .clk_out1(clk100),
        .clk_out2(clk200),
        .clk_out3(clk173),
        .locked(clkLock)
    );
    
    
    MemController ram(
    //Peripherals
    .clkLock(clkLock),
    .clk100(clk100),
    .clk200(clk200),
    .rst(rst),
    
//    //inouts
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
    
    //Memory connection VGA
    .request_read_vga(request_read_vga_in),
    .read_complete_vga(read_complete_vga_out),
    
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
    .rd_data_rt(rd_data_rt_a)
    );
endmodule
