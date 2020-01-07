`timescale 1ns/1ns
module ROM_320x240_tb();

	reg clk;
	reg [8:0] x;
	reg [7:0] y;
	wire [2:0] dout;
	
	
	// note that since the default image is black, everything will return the 
	// value of black
	
	ROM_320x240 uut(
		.clk (clk),
		.x (x),
		.y (y),
		.dout (dout)
	);
	
	always #2 clk = ~clk;
	
	initial begin
		clk = 0; x = 0; y = 0;
		
		#10 x = 100; y = 100;
		#10 x = 69; y = 69;
		#10 x = 10; y = 30;
		#10 x = 45; y = 80;
		#10;
		$stop;
	
	end


endmodule