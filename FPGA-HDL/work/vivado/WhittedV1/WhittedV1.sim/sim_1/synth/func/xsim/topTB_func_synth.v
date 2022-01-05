// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Sun Mar  7 20:32:01 2021
// Host        : Tony-Maloney running 64-bit major release  (build 9200)
// Command     : write_verilog -mode funcsim -nolib -force -file
//               C:/Users/ethan/Documents/GitHub/Ray-Tracing/FPGA-HDL/work/vivado/WhittedV1/WhittedV1.sim/sim_1/synth/func/xsim/topTB_func_synth.v
// Design      : deklet
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tftg256-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* NotValidForBitStream *)
module deklet
   (p_adc,
    cs,
    spi_clk,
    mosi,
    miso,
    adc_en,
    adc_clk,
    clk20);
  input [7:0]p_adc;
  input cs;
  input spi_clk;
  input mosi;
  output miso;
  output adc_en;
  output adc_clk;
  input clk20;

  wire adc_clk;
  wire adc_clk_OBUF;
  wire adc_en;
  wire clk20;
  wire clk20_IBUF;
  wire clk20_IBUF_BUFG;
  wire miso;
  wire p_0_in;

  OBUF adc_clk_OBUF_inst
       (.I(adc_clk_OBUF),
        .O(adc_clk));
  LUT1 #(
    .INIT(2'h1)) 
    adc_clk_i_1
       (.I0(adc_clk_OBUF),
        .O(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    adc_clk_reg
       (.C(clk20_IBUF_BUFG),
        .CE(1'b1),
        .D(p_0_in),
        .Q(adc_clk_OBUF),
        .R(1'b0));
  OBUF adc_en_OBUF_inst
       (.I(1'b1),
        .O(adc_en));
  BUFG clk20_IBUF_BUFG_inst
       (.I(clk20_IBUF),
        .O(clk20_IBUF_BUFG));
  IBUF clk20_IBUF_inst
       (.I(clk20),
        .O(clk20_IBUF));
  OBUFT miso_OBUF_inst
       (.I(1'b0),
        .O(miso),
        .T(1'b1));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
