// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Sat Sep 26 23:23:27 2020
// Host        : Tony-Maloney running 64-bit major release  (build 9200)
// Command     : write_verilog -mode funcsim -nolib -force -file {C:/Users/ethan/Documents/GitHub/Ray-Tracing/FPGA
//               Programs/RayTraceDemo/RayTraceDemo.sim/sim_1/synth/func/xsim/top_TB_func_synth.v}
// Design      : top
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tftg256-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* NotValidForBitStream *)
module top
   (button,
    led1,
    led2,
    led3,
    clk);
  input button;
  output led1;
  output led2;
  output led3;
  input clk;

  wire button;
  wire button_IBUF;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire \deb_reg_n_0_[5] ;
  wire led1;
  wire led1_OBUF;
  wire led2;
  wire led2_OBUF;
  wire led3;
  wire led3_OBUF;
  wire [4:0]p_0_out;
  wire \temp[0]_i_1_n_0 ;
  wire \temp[0]_i_2_n_0 ;
  wire \temp[1]_i_1_n_0 ;
  wire \temp[2]_i_1_n_0 ;
  wire \temp[3]_i_1_n_0 ;
  wire \temp_reg_n_0_[3] ;
  wire trig;
  wire trig1;
  wire trig_i_1_n_0;
PULLDOWN pulldown_led1
       (.O(led1));
PULLDOWN pulldown_led2
       (.O(led2));

  IBUF button_IBUF_inst
       (.I(button),
        .O(button_IBUF));
  BUFG clk_IBUF_BUFG_inst
       (.I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \deb_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(button_IBUF),
        .Q(p_0_out[4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \deb_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(p_0_out[4]),
        .Q(p_0_out[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \deb_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(p_0_out[3]),
        .Q(p_0_out[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \deb_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(p_0_out[2]),
        .Q(p_0_out[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \deb_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(p_0_out[1]),
        .Q(p_0_out[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \deb_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(p_0_out[0]),
        .Q(\deb_reg_n_0_[5] ),
        .R(1'b0));
  OBUF led1_OBUF_inst
       (.I(led1_OBUF),
        .O(led1));
  OBUF led2_OBUF_inst
       (.I(led2_OBUF),
        .O(led2));
  OBUF led3_OBUF_inst
       (.I(led3_OBUF),
        .O(led3));
  LUT6 #(
    .INIT(64'hFFFF7FFF00008000)) 
    \temp[0]_i_1 
       (.I0(led3_OBUF),
        .I1(\temp_reg_n_0_[3] ),
        .I2(led2_OBUF),
        .I3(\temp[0]_i_2_n_0 ),
        .I4(trig),
        .I5(led1_OBUF),
        .O(\temp[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \temp[0]_i_2 
       (.I0(p_0_out[0]),
        .I1(\deb_reg_n_0_[5] ),
        .I2(p_0_out[3]),
        .I3(p_0_out[4]),
        .I4(p_0_out[1]),
        .I5(p_0_out[2]),
        .O(\temp[0]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hFF7F0080)) 
    \temp[1]_i_1 
       (.I0(\temp_reg_n_0_[3] ),
        .I1(led3_OBUF),
        .I2(\temp[0]_i_2_n_0 ),
        .I3(trig),
        .I4(led2_OBUF),
        .O(\temp[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'hF708)) 
    \temp[2]_i_1 
       (.I0(\temp_reg_n_0_[3] ),
        .I1(\temp[0]_i_2_n_0 ),
        .I2(trig),
        .I3(led3_OBUF),
        .O(\temp[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'hB4)) 
    \temp[3]_i_1 
       (.I0(trig),
        .I1(\temp[0]_i_2_n_0 ),
        .I2(\temp_reg_n_0_[3] ),
        .O(\temp[3]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \temp_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\temp[0]_i_1_n_0 ),
        .Q(led1_OBUF),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \temp_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\temp[1]_i_1_n_0 ),
        .Q(led2_OBUF),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \temp_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\temp[2]_i_1_n_0 ),
        .Q(led3_OBUF),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \temp_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\temp[3]_i_1_n_0 ),
        .Q(\temp_reg_n_0_[3] ),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'hA8)) 
    trig_i_1
       (.I0(trig1),
        .I1(trig),
        .I2(\temp[0]_i_2_n_0 ),
        .O(trig_i_1_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    trig_i_2
       (.I0(p_0_out[0]),
        .I1(\deb_reg_n_0_[5] ),
        .I2(p_0_out[3]),
        .I3(p_0_out[4]),
        .I4(p_0_out[1]),
        .I5(p_0_out[2]),
        .O(trig1));
  FDRE #(
    .INIT(1'b0)) 
    trig_reg
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(trig_i_1_n_0),
        .Q(trig),
        .R(1'b0));
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
