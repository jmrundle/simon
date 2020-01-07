`timescale 1ns/1ns
module RAM_256x2_tb();

	reg clk, we;
	reg [7:0] raddr, waddr;
	reg [1:0] din;
	wire [1:0] dout;

	RAM_256x2 uut(
		.clk 		(clk),
		.we		(we),
		.raddr	(raddr),
		.waddr	(waddr),
		.din		(din),
		.dout		(dout)
	);
	
	always #2 clk = ~clk;
	
	initial begin
		clk = 0; we = 0; raddr = 0; waddr = 0; din = 0;
		
		#10 we = 1; waddr = 1; din = 1;
		#10 we = 0; raddr = 1;
		#10 raddr = 0;
		#10 we = 1; waddr = 2; din = 2;
		#10 we = 0; raddr = 2;
		#10;
		$stop;
	
	end


endmodule