`timescale 1ns/1ns

module controller_tb();
	reg clk;
	reg reset;

	// from datapath
	reg enter_pressed;
	reg key_pressed;
	reg key_released;
	reg valid_input;
	
	reg red_pulse;
	reg green_pulse;
	reg yellow_pulse;
	reg blue_pulse;
	
	reg input_eq_green;
	reg input_eq_red;
	reg input_eq_yellow;
	reg input_eq_blue;
	
	reg raddr_eq_level;
	reg waddr_eq_max;
	reg level_eq_max;
	
	reg wait_timer_pulse;
	reg disp_timer_pulse;
	
	reg correct;
	
	reg is_max_score;
	
	// to datapath
	wire s_raddr;
	wire en_raddr;
	wire s_waddr;
	wire en_waddr;
	wire s_level;
	wire en_level;
	wire s_max_score;
	wire en_max_score;
	wire [3:0] s_bg; 
	wire en_bg;
	wire en_rng;
	wire en_freq;
	wire s_freq;
	wire res_wait_timer;
	wire res_disp_timer;
	
	
	always #5 clk = ~clk;
	
	controller uut (
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
	
	
	
	initial begin
		clk = 0; reset = 0;
		enter_pressed = 0; key_pressed = 0; valid_input = 0;
		red_pulse = 0; green_pulse = 0; yellow_pulse = 0; blue_pulse = 0;
		raddr_eq_level = 0; waddr_eq_max = 0; level_eq_max = 0;
		wait_timer_pulse = 0; disp_timer_pulse = 0;
		correct = 0; key_released = 0;
		input_eq_green = 0; input_eq_red = 0; input_eq_yellow = 0; input_eq_blue = 0;
		is_max_score = 0;
		
		#10 enter_pressed = 1;
		#10 enter_pressed = 0; green_pulse = 1;
		#50 wait_timer_pulse = 1; 
		#10 wait_timer_pulse = 0;
		#50 disp_timer_pulse = 1;
		#10 disp_timer_pulse = 0;
		#50 wait_timer_pulse = 1;
		#10 wait_timer_pulse = 0;
		#50 disp_timer_pulse = 1; raddr_eq_level = 1;
		#10 disp_timer_pulse = 0; raddr_eq_level = 0;
		#20 key_pressed = 1; valid_input = 1; correct = 1;
		#10 key_pressed = 0; key_released = 1;
		#5 key_released = 0;
		#20 key_pressed = 1;
		#10 key_pressed = 0; raddr_eq_level = 1; key_released = 1;
		#5 key_released = 0;
		
		#10;
	
	$stop;
	end
	
endmodule
