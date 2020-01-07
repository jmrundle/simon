module ROM_10x12 (
	input clk,
	input [3:0] x,
	input [3:0] y,
	output reg [2:0] dout
	);
	// ROM for storing sprites
	
	parameter IMAGE_FILE = "black.mem";
   
   wire [6:0] addr  = 10*y + x;
   
   reg [2:0] mem [0:119];
   initial $readmemh(IMAGE_FILE, mem);

   always @(posedge clk)
      dout <= mem[addr];
   
endmodule