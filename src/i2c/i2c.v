
module i2c(i_clk, i_scl, i_sda, active);
	
	input i_clk;
	input i_scl;
	input i_sda;
	output active;

	wire scl, sda;
	reg prev_scl, prev_sda;
	reg active = 0;
	reg [7:0] rx_data = 0;
	reg [5:0] rx_bit_num;
	reg address_ok;
		
	wire scl_high;
	wire scl_low;
	wire scl_rise;
	wire scl_fall;
	
	wire sda_high;
	wire sda_low;
	wire sda_rise;
	wire sda_fall;
	
	wire start_condition;
	wire stop_condition;
	wire o_ack;
		

	assign scl = i_scl;
	assign sda = i_sda;
		
	always @ (posedge i_clk) begin
		prev_scl <= #1 scl;
		prev_sda <= #1 sda;
	end

	
	/*
	 * Some signals describing the state transitions for the scl
	 * and sda lines
	 */
	 
	assign sda_high =  prev_sda &  sda;
	assign sda_low  = !prev_sda & !sda;
	assign sda_rise = !prev_sda &  sda;
	assign sda_fall =  prev_sda & !sda;

	assign scl_high =  prev_scl &  scl;
	assign scl_low  = !prev_scl & !scl;
	assign scl_rise = !prev_scl &  scl;
	assign scl_fall =  prev_scl & !scl;
	

	/* 
	 * I2C start and stop conditions
	 */
	 
	assign start_condition = scl_high & sda_fall;
	assign stop_condition  = scl_high & sda_rise;


	/* 
	 * Check for interesting conditions on the I2C bus
	 */
		
	always @ (posedge i_clk) begin

		if (start_condition) begin
			active <= #1 1;
			rx_bit_num <= #1 0;
			address_ok <= #1 0;
		end

		
		else if (stop_condition) begin
			active <= 0;
		end
		
		
		else if (scl_rise) begin
			
			/* Clock one bit of data into the receive register */
			
			rx_data <= #1 { rx_data[6:0] , sda };
			if (rx_bit_num == 9) rx_bit_num <= #1 0; else rx_bit_num <= #1 rx_bit_num + 1;
			
			/* If we received bit 7 and the address is not ours, go back to inactive state */
			
			if (rx_bit_num == 7) begin
				if (rx_data[6:0] == 7'h22) begin
					address_ok <= #1 1;
				end else begin
					active <= #1 0;
				end
			end
		end
			
	end

	assign o_ack = (rx_bit_num == 9) & active & scl & prev_scl;
	
endmodule

/*
 * End
 */
