module RAM_256x2 (
	input				clk,
	input				we,
	input  		[7:0]	raddr,
	input  		[7:0]	waddr,
	input 	 	[1:0]	din,
	output reg 	[1:0]	dout
	);
	
	reg [1:0] mem [0:255];
	
	always @(posedge clk) begin
		if (we)
			mem[waddr] <= din;
		
		dout <= mem[raddr];
	end
	
endmodule
