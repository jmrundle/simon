`timescale 1ns/1ns
module lfsr_tb();

	reg clk;
	wire [1:0] q;
	
	
	lfsr uut(
		.clk (clk),
		.q (q)
	);
	
	
	always #5 clk = ~clk;
	
	initial begin
		clk = 0;
		#300;
		$stop;
	
	end


endmodule