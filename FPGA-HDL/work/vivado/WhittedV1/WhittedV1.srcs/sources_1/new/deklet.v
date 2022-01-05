
`define PULSE_LENGTH 20
`define PULSE_THRESH 100
`define PULSE_OFFSET 200

module deklet(input wire [7:0] p_adc,

			input wire cs,
			input wire spi_clk,
			input wire mosi,
			output reg miso,
			
			output reg adc_en,
			output reg adc_clk,
			
			
			input wire clk20);
		
		
		//stream ADC into BRAM
		//detect when an event has occured, #of continous samples above threshold
		//BRAM is 8190 x 8 this breaks down into 1170 per ADC 
		//adc1 0-1169
		//adc2 1170-2339
		//adc3 2340-3509
		//adc4 3510-4679
		//adc5 4680-5849
		//adc6 5850-7019
		//adc7 7020-8190
		
		reg pulse_detected;
		reg run_logging;
		
		reg [2:0] b_ptr;
		reg [13:0] d_ptr;
		
		reg [5:0] pulse_ctr;
		
		reg [1169:0] shift_reg0;
		reg [1169:0] shift_reg1;
		reg [1169:0] shift_reg2;
		reg [1169:0] shift_reg3;
		reg [1169:0] shift_reg4;
		reg [1169:0] shift_reg5;
		reg [1169:0] shift_reg6;
		reg [1169:0] shift_reg7;
		
		initial begin
		    shift_reg0 = 0;
			shift_reg1 = 0;
			shift_reg2 = 0;
			shift_reg3 = 0;
			shift_reg6 = 0;
			shift_reg5 = 0;
			shift_reg6 = 0;
			shift_reg7 = 0;
			pulse_ctr = 0;
			
			b_ptr = 0;
			d_ptr = 0;
			
			adc_en = 1;
			
			adc_clk = 0;
			pulse_detected = 0;
			run_logging = 1;
		end
		
		always @(posedge clk20) begin
			adc_clk <= ~adc_clk;
			
			if(cs) begin
			     if(b_ptr == 0)
			         miso <= shift_reg0[d_ptr];
			     else if(b_ptr == 3'd1)
			         miso <= shift_reg1[d_ptr];
			     else if(b_ptr == 3'd2)
			         miso <= shift_reg2[d_ptr];
			     else if(b_ptr == 3'd3)
			         miso <= shift_reg3[d_ptr];
			     else if(b_ptr == 3'd4)
			         miso <= shift_reg4[d_ptr];
			     else if(b_ptr == 3'd5)
			         miso <= shift_reg5[d_ptr];
			     else if(b_ptr == 3'd6)
			         miso <= shift_reg6[d_ptr];
			     else if(b_ptr == 3'd7) begin
			         miso <= shift_reg7[d_ptr];
			         d_ptr <= d_ptr + 1;
			     end
			     
			     b_ptr <= b_ptr + 1;
			end
			else begin
			     b_ptr <= 0;
			     d_ptr <= 0;
		    end
			
			if(adc_clk & run_logging) begin
				shift_reg0 <= shift_reg0 << 1;
				shift_reg1 <= shift_reg1 << 1;
				shift_reg2 <= shift_reg2 << 1;
				shift_reg3 <= shift_reg3 << 1;
				shift_reg4 <= shift_reg4 << 1;
				shift_reg5 <= shift_reg5 << 1;
				shift_reg6 <= shift_reg6 << 1;
				shift_reg7 <= shift_reg7 << 1;
				
				shift_reg0[0] <= p_adc[0];
				shift_reg1[0] <= p_adc[1];
				shift_reg2[0] <= p_adc[2];
				shift_reg3[0] <= p_adc[3];
				shift_reg4[0] <= p_adc[4];
				shift_reg5[0] <= p_adc[5];
				shift_reg6[0] <= p_adc[6];
				shift_reg7[0] <= p_adc[7];
				
				if(p_adc >= `PULSE_THRESH | pulse_detected) begin
					pulse_ctr <= pulse_ctr + 1;
					if(pulse_ctr >= `PULSE_OFFSET) begin
						run_logging <= 0;
						adc_en <= 0;
					end
				end
				else
					pulse_ctr <= 0;
					
				if(pulse_ctr >= `PULSE_LENGTH & ~pulse_detected)
					pulse_detected <= 1;
			end
		end
endmodule