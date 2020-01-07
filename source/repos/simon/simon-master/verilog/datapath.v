module datapath(
	input clk,
	
	// from RAM
	input [1:0] dout,			// data being pointed to by raddr
	
	// from Keyboard controller
	input [7:0] keycode,
	input 		make,
	input 		keycode_ready,
	
	// from controller
	input s_raddr,
	input en_raddr,
	input s_waddr,
	input en_waddr,
	input s_level,
	input en_level,
	input s_max_score,
	input en_max_score,
	input [3:0] s_bg, 
	input en_bg,
	input en_rng,
	input en_freq,
	input [2:0] s_freq,
	input res_wait_timer,
	input res_disp_timer,
	
	// to controller
	output enter_pressed,
	output key_pressed,
	output key_released,
	output valid_input,
	
	output red_pulse,
	output green_pulse,
	output yellow_pulse,
	output blue_pulse,
	
	output input_eq_green,
	output input_eq_red,
	output input_eq_yellow,
	output input_eq_blue,
	
	output raddr_eq_level,
	output waddr_eq_max,
	output raddr_eq_max,
	output level_eq_max,
	
	output correct,
	
	output is_max_score,
	
	output wait_timer_pulse,
	output disp_timer_pulse,
	
	
	// to RAM
	output 		 		we,		// should we store data in RAM?
	output 	  [1:0] 	din, 		// data to be stored in RAM (rng)
	output reg [7:0] 	raddr, 	// addr to get data in RAM
	output reg [7:0] 	waddr, 	// addr to write data in RAM
	
	// switch between backgrounds
	output reg [2:0] bg,
	// game level
	output reg [4:0] level_01,
	output reg [4:0] level_10,
	output reg [4:0] max_score_01,
	output reg [4:0] max_score_10,
	
	// audio
	output audio_res,
	output reg [19:0] half_wav
	);
	
	
	
	/****************************************************************************/
	/* PARAMETERS																*/
	/****************************************************************************/
	parameter MAX 				= 8'd99;
	parameter ENTER_KEY 		= 3'd4;
	parameter INVALID_INPUT	= 3'd5;

	
	/****************************************************************************/
	/* INTERNAL WIRES															*/
	/****************************************************************************/
	wire [2:0] code;								// 3 bit user input
	wire [6:0] level 		= 10*level_10 + level_01;
	wire [6:0] max_score = 10*max_score_10 + max_score_01;
	
	/****************************************************************************/
	/* INTERNAL MODULES															*/
	/****************************************************************************/
	lfsr random_number_generator (
		.clk  	(clk),
		.q 		(din)		// load into RAM when write is enabled
	);
	
	timer wait_timer (
		.clk   (clk),
		.reset (res_wait_timer),
		.max_count (26'd10_000_000),   // pulse every 1/5th of second
		.pulse (wait_timer_pulse)
	);
	
	timer disp_timer (
		.clk   (clk),
		.reset (res_disp_timer),
		.max_count (26'd25_000_000),  // pulse every 1/2 second
		.pulse (disp_timer_pulse)
	);
	
	keycode_decoder input_decoder(
		.keycode	(keycode),
		.code		(code)
	);
	

	/****************************************************************************/
	/* ASSIGN STATEMENTS														*/
	/****************************************************************************/
	assign key_pressed		= keycode_ready && make;
	assign key_released 		= keycode_ready && ~make;
	assign enter_pressed		= (key_pressed && code == ENTER_KEY);
	assign valid_input 		= (code != ENTER_KEY && code != INVALID_INPUT);
	
	assign green_pulse	= (dout == 2'd0);
	assign red_pulse		= (dout == 2'd1);
	assign yellow_pulse 	= (dout == 2'd2);
	assign blue_pulse		= (dout == 2'd3);
	
	assign input_eq_green	= (code == 2'd0);
	assign input_eq_red		= (code == 2'd1);
	assign input_eq_yellow	= (code == 2'd2);
	assign input_eq_blue		= (code == 2'd3);
	
	assign raddr_eq_level	= (raddr == level);	
	assign waddr_eq_max		= (waddr == MAX);
	assign level_eq_max		= (level == MAX);
	
	assign we = en_rng;	// only time we store data in RAM is when en_rng is true
	
	assign correct = (code == dout);
	
	assign is_max_score = (level >= max_score);
	
	assign audio_res	= ~en_freq;		// turn off reset when we want to use audio
	
	
	/****************************************************************************/
	/* REGISTER UPDATES															*/
	/****************************************************************************/
	always @(posedge clk) begin
		if (en_raddr)
			if (s_raddr)
				raddr <= raddr + 1;
			else 
				raddr <= 0;
	end
	
	always @(posedge clk) begin
		if (en_waddr)
			if (s_waddr)
				waddr <= waddr + 1;
			else 
				waddr <= 0;
	end
	
	always @(posedge clk) begin
		if (en_level)
			if (s_level) begin
				if (level_01 == 4'd9) begin
					level_01 = 4'd0;
					level_10 <= level_10 + 1;
				end else
					level_01 <= level_01 + 1;
				
			end else begin
				level_10 <= 0;
				level_01 <= 0;
			end
	end
	
	always @(posedge clk) begin
		if (en_max_score)
			if (s_max_score) begin
				max_score_01 = level_01;
				max_score_10 = level_10;
			end else begin
				max_score_10 <= 0;
				max_score_01 <= 0;
			end
	end
	
	always @(posedge clk) begin
		if (en_bg)
			case (s_bg) 
				0: bg = 3'd0;
				1: bg = 3'd1;
				2: bg = 3'd2;
				3: bg = 3'd3;
				4: bg = 3'd4;
				5: bg = 3'd5;
				6: bg = 3'd6;
				7: bg = 3'd7;
				default: bg = 3'd0;
			endcase
	end
	
	always @(posedge clk) begin
		if (en_freq)
			case (s_freq)
				0: half_wav = 20'd95_784;
				1: half_wav = 20'd75_758;
				2: half_wav = 20'd63_776;
				3: half_wav = 20'd47_801;
				4: half_wav = 20'd520_833;
				default: half_wav = 20'd0;
			endcase
	end
	

		
	
endmodule
