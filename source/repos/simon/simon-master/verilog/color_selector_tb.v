`timescale 1ns/1ns

module color_selector_tb();
	reg clk;
	reg [8:0] xvga;
	reg [7:0] yvga;
	reg [3:0] level_10, level_01, max_score_10, max_score_01;
	reg [2:0] bg;
	
	wire [2:0] color;
	
	color_selector uut (
		.clk 				(clk),
		.xvga 			(xvga),
		.yvga 			(yvga),
		.level_01 		(level_01),
		.level_10 		(level_10),
		.max_score_01 	(max_score_01),
		.max_score_10 	(max_score_10),
		.bg				(bg),
		.color			(color)
	);
	
	always #2 clk = ~clk;
	
	initial begin
	
		clk = 0; xvga = 0; yvga = 0; level_10 = 0; level_01 = 0; max_score_10 = 0; max_score_01 = 0; bg = 1;
		#10 xvga = 73; yvga = 5;
		#10 xvga = 74;
		#10 level_10 = 1;
		#10 xvga = 75;
		#10 level_10 = 8;
		#10 yvga = 6;
		#10;
		$stop;
	
	end
	
	
	
endmodule