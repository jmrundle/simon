`timescale 1ns/1ns
module ROM_10x12_tb();

	reg clk;
	reg [3:0] x;
	reg [3:0] y;
	wire [2:0] dout;
	
	ROM_10x12 uut(
		.clk (clk),
		.x (x),
		.y (y),
		.dout (dout)
	);
	
	always #2 clk = ~clk;
	
	initial begin
	
		clk = 0; x = 0; y = 0;
		
		#10 x = 1;
		#10 y = 1;
		#10 x = 2;
		#10 y = 3;
		#10;
		
		$stop;
	
	end


endmodule