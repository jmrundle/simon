module bg_mux (
	input [2:0] bg0_color,
	input [2:0] bg1_color,
	input [2:0] bg2_color,
	input [2:0] bg3_color,
	input [2:0] bg4_color,
	input [2:0] bg5_color,
	input [2:0] bg6_color,
	input [2:0] bg7_color,
	input [2:0]	bg,
	output reg [2:0] color
	);
	// mux to switch between 8 of the available backgrounds
	
	always @(*)
		case (bg)
			0: color = bg0_color;
			1: color = bg1_color;
			2: color = bg2_color;
			3: color = bg3_color;
			4: color = bg4_color;
			5: color = bg5_color;
			6: color = bg6_color;
			7: color = bg7_color;
		endcase
	
endmodule
