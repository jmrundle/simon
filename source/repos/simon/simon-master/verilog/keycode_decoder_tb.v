`timescale 1ns/1ns
module keycode_decoder_tb();

	reg [7:0] keycode;
	wire [2:0] code;
	
	keycode_decoder uut(
		.keycode (keycode),
		.code (code)
	);
	
	
	initial begin
		keycode = 0;
		#10 keycode = 8'h5A;
		#10 keycode = 8'h01;
		#10 keycode = 8'h15;
		#10 keycode = 8'h1D;
		#10 keycode = 8'h1C;
		#10 keycode = 8'h1B;
		#10;
		$stop;
	
	end
	
	
endmodule