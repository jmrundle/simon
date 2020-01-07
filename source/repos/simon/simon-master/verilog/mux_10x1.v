module mux_10x1 (
	input [2:0] d0, d1, d2, d3, d4, d5, d6, d7, d8, d9,
	input [3:0] s,
	output reg [2:0] f
	);
	
	always @(d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, s) 
		case (s)
			0: f = d0;
			1: f = d1;
			2: f = d2;
			3: f = d3;
			4: f = d4;
			5: f = d5;
			6: f = d6;
			7: f = d7;
			8: f = d8;
			9: f = d9;
			default: f = d0;
		endcase
	
endmodule

	