`timescale 1ns/1ns
module datapath_tb();


	reg clk;
	
	// from RAM
	reg [1:0] dout;			// data being pointed to by raddr
	
	// from Keyboard controller
	reg 		make;
	reg [7:0] keycode;
	reg		keycode_ready;
	
	// from controller
	reg s_raddr;
	reg en_raddr;
	reg s_waddr;
	reg en_waddr;
	reg s_level;
	reg en_level;
	reg s_max_score;
	reg en_max_score;
	reg [3:0] s_bg; 
	reg en_bg;
	reg en_rng;
	reg en_freq;
	reg [2:0] s_freq;
	reg res_wait_timer;
	reg res_disp_timer;
	
	// to controller
	wire enter_pressed;
	wire key_pressed;
	wire key_released;
	wire valid_input;
	
	wire red_pulse;
	wire green_pulse;
	wire yellow_pulse;
	wire blue_pulse;
	
	wire input_eq_green;
	wire input_eq_red;
	wire input_eq_yellow;
	wire input_eq_blue;
	
	wire raddr_eq_level;
	wire waddr_eq_max;
	wire raddr_eq_max;
	wire level_eq_max;
	
	wire correct;
	
	wire is_max_score;
	
	wire wait_timer_pulse;
	wire disp_timer_pulse;
	
	
	// to RAM
	wire 		 		we;		// should we store data in RAM?
	wire 	  [1:0] 	din; 		// data to be stored in RAM (rng)
	wire [7:0] 	raddr; 	// addr to get data in RAM
	wire [7:0] 	waddr; 	// addr to write data in RAM
	
	// switch between backgrounds
	wire [2:0] bg;
	
	wire [4:0] level_01;
	wire [4:0] level_10;
	wire [4:0] max_score_01;
	wire [4:0] max_score_10;
	
	// audio
	wire audio_res;
	wire [19:0] half_wav;

	always #5 clk = ~clk;
	
	
	datapath uut (
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

	initial begin
		clk = 0;
		s_raddr = 0; en_raddr = 1; s_waddr = 0; en_waddr = 1;
		s_level = 0; en_level = 1; s_bg = 0; en_bg = 1;
		en_rng = 0;
		en_freq = 0;
		keycode_ready = 0;
		s_max_score = 0;
		en_max_score = 1;
		s_freq = 0;
		
		res_wait_timer = 1; res_disp_timer = 1;
		
		dout = 2'd0;
		
		make = 0; keycode = 8'd0;
		
		
		#10 en_level = 1; s_level = 1;	// level <= level + 1
		#10 en_level = 0;
		
		#10 en_raddr = 1; s_raddr = 0; 	// raddr <= 0
		#10 en_raddr = 1; s_raddr = 1;  	// raddr <= raddr + 1
		#300 en_raddr = 0;					
	
		#10 en_freq = 1;
		#10 en_freq = 0;
		
		#10 en_rng = 1;
		#10 en_rng = 0;
		
		#10 res_wait_timer = 0;
		#200 res_wait_timer = 1;
		
		#10 res_disp_timer = 0;
		#200 res_disp_timer = 1;
		
		#10 en_bg = 1; s_bg = 5;
		
		#10 dout = 3'd1; keycode = 8'h1D; make = 1; // trigger correct (user and computer select green)
		#20;
		
		#10;
		
	$stop;
	end
	
	
endmodule