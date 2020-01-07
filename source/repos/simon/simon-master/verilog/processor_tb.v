`timescale 1ns/1ns
module processor_tb();

	reg				clk;
	reg 				reset;
	reg 	[7:0]		keycode;
	reg				keycode_ready;
	reg				make;
	
	wire	[4:0]		level_01, level_10, max_score_01, max_score_10;
	wire  [2:0] 	bg;
	wire 				audio_res;
	wire	[19:0]	half_wav;


	processor uut(
		.clk				(clk),
		.reset			(reset),
		.keycode			(keycode),
		.keycode_ready	(keycode_ready),
		.make				(make),
		.level_01		(level_01),
		.level_10		(level_10),
		.max_score_01	(max_score_01),
		.max_score_10	(max_score_10),
		.bg				(bg),
		.audio_res		(audio_res),
		.half_wav		(half_wav)
		);


	always #2 	clk = ~clk;
	
	
	initial begin
	
		clk = 0; reset = 0; keycode = 8'd0; make = 0; keycode_ready = 0;
		
		#12 keycode = 8'h5A; make = 1; keycode_ready = 1;
		#4 keycode_ready = 0;
		
		// generate sequence, display sequence, and begin waiting for input
		#200;	
		
		// give correct input
		#4 keycode_ready = 1; keycode = 8'h1b; 
	
	
		#4 keycode_ready = 0; 
		
		// display next item in sequence
		#100;
		
		$stop;
	
	end




endmodule
