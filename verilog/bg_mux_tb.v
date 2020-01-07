`timescale 1ns/1ns
module bg_mux_tb();

	reg [2:0] bg0_color, bg1_color, bg2_color, bg3_color, bg4_color, bg5_color, bg6_color, bg7_color;
	reg [2:0] bg;
	
	wire [2:0] color;

	bg_mux uut(
		.bg0_color (bg0_color),
		.bg1_color (bg1_color),
		.bg2_color (bg2_color),
		.bg3_color (bg3_color),
		.bg4_color (bg4_color),
		.bg5_color (bg5_color),
		.bg6_color (bg6_color),
		.bg7_color (bg7_color),
		.bg		  (bg),
		.color 	  (color)
	);
	
	initial begin
		bg0_color = 0; bg1_color = 1; bg2_color = 2; bg3_color = 3; bg4_color = 4;
		bg5_color = 5; bg6_color = 6; bg7_color = 7;
		
		bg = 0;
		#5 bg = 1;
		#5 bg = 2;
		#5 bg = 3;
		#5 bg = 4;
		#5 bg = 5;
		#5 bg = 6;
		#5 bg = 7;
		#5 bg = 0;
		#5;
		$stop;
	
	end
	
	
endmodule