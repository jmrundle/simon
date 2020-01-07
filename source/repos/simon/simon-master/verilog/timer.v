module timer (
	input clk,
	input reset,
	input [25:0] max_count,		// how often our timer sends a pulse
	output pulse
	);
	
	reg [25:0] count;
	initial count = 26'd0;
	
	assign pulse = (count == max_count);
		
	always @(posedge clk) begin	
		if (reset | pulse)
			count <= 0;
		else
			count <= count + 1;
	end

endmodule
