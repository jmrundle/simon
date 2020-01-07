`timescale 1ns/1ns
module digit_sprite_tb();

	reg clk;
	reg [8:0] xvga;
	reg [7:0] yvga;
	reg [3:0] number;
	
	wire [2:0] color;
	
	
	digit_sprite uut(
		.clk (clk),
		.xvga (xvga),
		.yvga (yvga),
		.number (number),
		.color (color)
	);

	
	always #2 clk = ~clk;
	
	initial begin
	
		clk = 0; xvga = 0; yvga = 0; number = 0;
		
		#10 xvga = 2; yvga = 1;
		#10 xvga = 3; yvga = 1;
		#10 number = 1;
		#10 xvga = 5; yvga = 1;
		#10;
		
		$stop;
	
	end


endmodule