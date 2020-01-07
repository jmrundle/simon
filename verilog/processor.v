module processor (
	input clk,
	input reset,
	input [7:0] keycode,
	input			make,
	input			keycode_ready,
	output [4:0] level_01, level_10, max_score_01, max_score_10,
	output [2:0] bg,
	output audio_res,
	output [19:0] half_wav
	);
	
	
	wire [7:0] raddr, waddr;
	wire [1:0] din, dout;

	wire enter_pressed, key_pressed, key_released, valid_input;
	wire red_pulse, green_pulse, yellow_pulse, blue_pulse;
	wire input_eq_green, input_eq_red, input_eq_yellow, input_eq_blue;
	wire raddr_eq_level, waddr_eq_max, level_eq_max;
	wire correct;
	
	wire is_max_score;

	wire s_raddr, en_raddr;
	wire s_waddr, en_waddr;
	wire s_level, en_level;
	wire s_max_score, en_max_score;
	wire [3:0] s_bg;
	wire en_bg;
	wire we;

	wire en_rng;
	
	wire en_freq;
	wire [2:0] s_freq;
	
	wire res_wait_timer, res_disp_timer;
	wire wait_timer_pulse, disp_timer_pulse;
	
	
	controller controller (
		.clk (clk),
		.reset (reset),
		// from datapath
		.enter_pressed (enter_pressed),
		.key_pressed 	(key_pressed),
		.key_released	(key_released),
		.valid_input 	(valid_input),
		
		.red_pulse 		(red_pulse),
		.green_pulse 	(green_pulse),
		.yellow_pulse 	(yellow_pulse),
		.blue_pulse 	(blue_pulse),
		
		.input_eq_green	(input_eq_green),
		.input_eq_red		(input_eq_red),
		.input_eq_yellow	(input_eq_yellow),
		.input_eq_blue		(input_eq_blue),
		
		.raddr_eq_level	(raddr_eq_level),
		.waddr_eq_max 		(waddr_eq_max),
		.level_eq_max 		(level_eq_max),
		
		.correct	(correct),
		
		.is_max_score (is_max_score),
		
		.wait_timer_pulse (wait_timer_pulse),
		.disp_timer_pulse (disp_timer_pulse),
		
		// to datapath
		.s_raddr 		 (s_raddr),
		.en_raddr 		 (en_raddr),
		.s_waddr 		 (s_waddr),
		.en_waddr 		 (en_waddr),
		.s_level 		 (s_level),
		.en_level 		 (en_level),
		.s_max_score	 (s_max_score),
		.en_max_score	 (en_max_score),
		.s_bg 		 	 (s_bg), 
		.en_bg 			 (en_bg),
		.en_rng 			 (en_rng),
		.en_freq 	 	 (en_freq),
		.s_freq 			 (s_freq),
		.res_wait_timer (res_wait_timer),
		.res_disp_timer (res_disp_timer)
	);
	
	datapath datapath (
		.clk (clk),
		
		// input from RAM
		.dout (dout),
		
		// input from PS2 controller
		.keycode 		(keycode),
		.make 			(make),
		.keycode_ready	(keycode_ready),
		
		// from controller
		.s_raddr			(s_raddr),
		.en_raddr		(en_raddr),
		.s_waddr		 	(s_waddr),
		.en_waddr		(en_waddr),
		.s_level 		(s_level),
		.en_level 		(en_level),
		.s_max_score	 (s_max_score),
		.en_max_score	 (en_max_score),
		.s_bg 			(s_bg), 
		.en_bg 			(en_bg),
		.en_rng 			(en_rng),
		.en_freq 		(en_freq),
		.s_freq 			(s_freq),
		.res_wait_timer (res_wait_timer),
		.res_disp_timer (res_disp_timer),
		
		// to controller
		.enter_pressed 	(enter_pressed),
		.key_pressed 		(key_pressed),
		.key_released		(key_released),
		.valid_input 		(valid_input),
		.red_pulse	 		(red_pulse),
		.green_pulse 		(green_pulse),
		.yellow_pulse 		(yellow_pulse),
		.blue_pulse 		(blue_pulse),
		.input_eq_green	(input_eq_green),
		.input_eq_red		(input_eq_red),
		.input_eq_yellow	(input_eq_yellow),
		.input_eq_blue		(input_eq_blue),
		.raddr_eq_level 	(raddr_eq_level),
		.waddr_eq_max 		(waddr_eq_max),
		.level_eq_max 		(level_eq_max),
		.correct				(correct),
		.is_max_score (is_max_score),
		.wait_timer_pulse (wait_timer_pulse),
		.disp_timer_pulse (disp_timer_pulse),
		
		// output to RAM
		.we 	 (we),
		.din	 (din),
		.raddr (raddr),
		.waddr (waddr),
		
		// select background
		.bg			(bg),
		
		// audio
		.audio_res 	(audio_res),
		.half_wav	(half_wav),
		
		// level information
		.level_01 (level_01),
		.level_10 (level_10),
		.max_score_01 (max_score_01),
		.max_score_10 (max_score_10)
	);
	
	RAM_256x2 sequence_RAM (
		.clk		(clk),
		.we		(we),
		.din		(din),
		.raddr	(raddr),
		.waddr	(waddr),
		.dout		(dout)
	);
	

endmodule

