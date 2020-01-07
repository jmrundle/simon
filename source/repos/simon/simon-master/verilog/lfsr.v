module lfsr (
	input 			clk,
	output [1:0] 	q
	);
	
	// seed
	reg [7:0] rando;
	initial rando = 8'd1;
	
	always @(posedge clk)
		rando <= {rando[6:0], rando[7]^rando[0]};
	
	assign q = rando[1:0];
	
endmodule
