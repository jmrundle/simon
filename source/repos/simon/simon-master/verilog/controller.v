module controller (
	input clk,
	input reset,

	// from datapath
	input enter_pressed,
	input key_pressed,
	input key_released,
	input valid_input,
	
	input red_pulse,
	input green_pulse,
	input yellow_pulse,
	input blue_pulse,
	
	input input_eq_green,
	input input_eq_red,
	input input_eq_yellow,
	input input_eq_blue,
	
	input raddr_eq_level,
	input waddr_eq_max,
	input level_eq_max,
	
	input wait_timer_pulse,
	input disp_timer_pulse,
	
	input correct,
	
	input is_max_score,

	
	// to datapath
	output reg s_raddr,
	output reg en_raddr,
	output reg s_waddr,
	output reg en_waddr,
	output reg s_level,
	output reg en_level,
	output reg s_max_score,
	output reg en_max_score,
	output reg [3:0] s_bg, 
	output reg en_bg,
	output reg en_rng,
	output reg en_freq,
	output reg [2:0] s_freq,
	output reg res_wait_timer,
	output reg res_disp_timer
	);
	
	parameter INIT_SYSTEM		= 6'd0;
	parameter WAIT_SCREEN 		= 6'd1;
	parameter INIT_SEQ_GEN		= 6'd2;
	parameter GET_RAND_NUM 		= 6'd3;
	parameter INCR_WADDR			= 6'd4;
	parameter INIT_DISP			= 6'd5;
	parameter READ_MEM			= 6'd6;
	parameter WAIT_FOR_PULSE	= 6'd7;
	parameter RED_FLASH			= 6'd8;
	parameter YELLOW_FLASH		= 6'd9;
	parameter GREEN_FLASH		= 6'd10;
	parameter BLUE_FLASH			= 6'd11;
	parameter INCR_RADDR_1		= 6'd12;
	parameter RES_RADDR			= 6'd13;
	parameter WAIT_FOR_INPUT	= 6'd14;
	parameter USER_GREEN_FLASH = 6'd15;
	parameter USER_RED_FLASH	= 6'd16;
	parameter USER_YELLOW_FLASH = 6'd17;
	parameter USER_BLUE_FLASH	= 6'd18;
	parameter INCR_RADDR_2		= 6'd19;
	parameter INCR_LEVEL			= 6'd20;
	parameter SET_MAX_SCORE		= 6'd21;
	parameter FAIL_REVEAL		= 6'd22;
	parameter FAIL_GREEN			= 6'd23;
	parameter FAIL_RED 			= 6'd24;
	parameter FAIL_YELLOW		= 6'd25;
	parameter FAIL_BLUE			= 6'd26;
	parameter FAIL_SCREEN		= 6'd27;
	parameter WIN_SCREEN			= 6'd28;


	reg [5:0] state, next_state;
	
	always @(posedge clk) begin
		if (reset)
			state <= INIT_SYSTEM;
		else
			state <= next_state;
	end
	
	
	always @(*) begin
		// initialize FSM outputs to default values
		en_waddr = 0;
		s_waddr	 = 0;
				
		en_raddr = 0;
		s_raddr	 = 0;

		en_level = 0;
		s_level  = 0;
		
		en_max_score = 0;
		s_max_score = 0;
		
		en_bg = 1;
		s_bg  = 4'd1;

		en_rng = 0;

		en_freq = 0;
		s_freq = 3'd0;
		
		res_wait_timer = 1;
		res_disp_timer = 1;
		
		
		next_state = INIT_SYSTEM;
		
		case (state)
			
			INIT_SYSTEM: begin			
				// init max score
				en_max_score = 1;
				s_max_score = 0;
				
				next_state = WAIT_SCREEN;
			end
			
			WAIT_SCREEN: begin
				// bg <= 0
				en_bg = 1;
				s_bg  = 4'd0;
				
				if (enter_pressed)
					next_state = INIT_SEQ_GEN;
				else
					next_state = WAIT_SCREEN;
			end
			
			INIT_SEQ_GEN: begin
				// level <= 0
				en_level = 1;
				s_level  = 0;
				
				// waddr <= 0
				en_waddr = 1;
				s_waddr  = 0;
				
				next_state = GET_RAND_NUM;
			end	
			
			GET_RAND_NUM:	begin
				// store rng in memory
				en_rng = 1;
				next_state = INCR_WADDR;
			end
			
			INCR_WADDR: begin
				// waddr <= waddr + 1
				en_waddr= 1;
				s_waddr = 1;
				
				if (waddr_eq_max)
					next_state = INIT_DISP;
				else
					next_state = GET_RAND_NUM;
			end
			
			INIT_DISP: begin
				// raddr <= 0
				en_raddr = 1;
				s_raddr	= 0;
				
				res_disp_timer = 0;
				
				if (disp_timer_pulse)
					next_state = READ_MEM;
				else
					next_state = INIT_DISP;
			end

			READ_MEM: begin
				// synchronous memory
				next_state = WAIT_FOR_PULSE;
			end

			WAIT_FOR_PULSE: begin
				// enable wait timer
				res_wait_timer = 0;
				
				if (wait_timer_pulse && green_pulse)
					next_state = GREEN_FLASH;
				else if (wait_timer_pulse && red_pulse)
					next_state = RED_FLASH;
				else if (wait_timer_pulse && yellow_pulse)
					next_state = YELLOW_FLASH;
				else if (wait_timer_pulse && blue_pulse)
					next_state = BLUE_FLASH;
				else
					next_state = WAIT_FOR_PULSE;
			end

			
			GREEN_FLASH: begin
				// enable disp timer
				res_disp_timer = 0;
				
				en_freq = 1;
				s_freq = 3'd0;
				
				en_bg = 1;
				s_bg  = 4'd2;

				if (disp_timer_pulse)
					next_state = INCR_RADDR_1;
				else
					next_state = GREEN_FLASH;
			end
			
			RED_FLASH: begin
				// enable disp timer
				
				res_disp_timer = 0;
				
				en_freq = 1;
				s_freq = 3'd1;
				
				en_bg = 1;
				s_bg  = 4'd3;

				if (disp_timer_pulse)
					next_state = INCR_RADDR_1;
				else
					next_state = RED_FLASH;
			end

			YELLOW_FLASH: begin
				// enable disp timer
				res_disp_timer = 0;
				
				en_freq = 1;
				s_freq = 3'd2;
				
				en_bg = 1;
				s_bg  = 4'd4;

				if (disp_timer_pulse)
					next_state = INCR_RADDR_1;
				else
					next_state = YELLOW_FLASH;
			end


			BLUE_FLASH: begin
				// enable disp timer
				res_disp_timer = 0;
				
				en_freq = 1;
				s_freq = 3'd3;
				
				en_bg = 1;
				s_bg  = 4'd5;

				if (disp_timer_pulse)
					next_state = INCR_RADDR_1;
				else
					next_state = BLUE_FLASH;
			end

			INCR_RADDR_1: begin
				// raddr <= raddr + 1
				en_raddr = 1;
				s_raddr  = 1;

				if (raddr_eq_level)
					next_state = RES_RADDR;
				else
					next_state = READ_MEM;
			end
			
			RES_RADDR: begin	
				// raddr <= 0
				en_raddr = 1;
				s_raddr	= 0;
				
				next_state = WAIT_FOR_INPUT;
			end
			
			WAIT_FOR_INPUT: begin
				// redirect input to corresponding state
				
				if (~key_pressed | ~valid_input)
					next_state = WAIT_FOR_INPUT;
				else if (input_eq_green)
					next_state = USER_GREEN_FLASH;
				else if (input_eq_red)
					next_state = USER_RED_FLASH;
				else if (input_eq_yellow)
					next_state = USER_YELLOW_FLASH;
				else if (input_eq_blue)
					next_state = USER_BLUE_FLASH;
			end
			
			USER_GREEN_FLASH: begin
				en_bg = 1;
				s_bg  = 4'd2;
				
				en_freq = 1;
				s_freq = 3'd0;
				
				if (key_released && correct)
					next_state = INCR_RADDR_2;
				else if (key_released && ~correct)
					next_state = FAIL_REVEAL;
				else
					next_state = USER_GREEN_FLASH;
			end
			
			USER_RED_FLASH: begin
				en_bg = 1;
				s_bg  = 4'd3;
				
				en_freq = 1;
				s_freq = 3'd1;
				
				if (key_released && correct)
					next_state = INCR_RADDR_2;
				else if (key_released && ~correct)
					next_state = FAIL_REVEAL;
				else
					next_state = USER_RED_FLASH;
			end
			
			USER_YELLOW_FLASH: begin
				en_bg = 1;
				s_bg  = 4'd4;
				
				en_freq = 1;
				s_freq = 3'd2;
				
				if (key_released && correct)
					next_state = INCR_RADDR_2;
				else if (key_released && ~correct)
					next_state = FAIL_REVEAL;
				else
					next_state = USER_YELLOW_FLASH;
			end
			
			USER_BLUE_FLASH: begin
				en_bg = 1;
				s_bg  = 4'd5;
				
				en_freq = 1;
				s_freq = 3'd3;
				
				if (key_released && correct)
					next_state = INCR_RADDR_2;
				else if (key_released && ~correct)
					next_state = FAIL_REVEAL;
				else
					next_state = USER_BLUE_FLASH;
			end
			
			INCR_RADDR_2: begin	
				// raddr <= raddr + 1;
				en_raddr = 1;
				s_raddr  = 1;
				
				if (raddr_eq_level)
					next_state = INCR_LEVEL;
				else
					next_state = WAIT_FOR_INPUT;
			end
			
			INCR_LEVEL: begin
				// level <= level + 1;
				en_level = 1;
				s_level  = 1;
				
				if (level_eq_max)
					next_state = WIN_SCREEN;
				else if (is_max_score)
					next_state = SET_MAX_SCORE;
				else
					next_state = INIT_DISP;
			end
			
			SET_MAX_SCORE: begin
				// update max score
				en_max_score = 1;
				s_max_score = 1;
				
				next_state = INIT_DISP;
			end
			
			FAIL_REVEAL: begin
				if (green_pulse)
					next_state = FAIL_GREEN;
				else if (red_pulse)
					next_state = FAIL_RED;
				else if (yellow_pulse)
					next_state = FAIL_YELLOW;
				else if (blue_pulse)
					next_state=  FAIL_BLUE;
			end
			
			FAIL_GREEN: begin
				en_bg = 1;
				s_bg = 4'd2;
				
				en_freq = 1;
				s_freq = 3'd4;
				
				res_disp_timer = 0;
				
				if (disp_timer_pulse)
					next_state = FAIL_SCREEN;
				else
					next_state = FAIL_GREEN;
			end	
			
			FAIL_RED: begin
				en_bg = 1;
				s_bg = 4'd3;
				
				en_freq = 1;
				s_freq = 3'd4;
				
				res_disp_timer = 0;
				
				if (disp_timer_pulse)
					next_state = FAIL_SCREEN;
				else
					next_state = FAIL_RED;
			end			
			
			FAIL_YELLOW: begin
				en_bg = 1;
				s_bg = 4'd4;
				
				en_freq = 1;
				s_freq = 3'd4;
				
				res_disp_timer = 0;
				
				if (disp_timer_pulse)
					next_state = FAIL_SCREEN;
				else
					next_state = FAIL_YELLOW;
			end	
			
			FAIL_BLUE: begin
				en_bg = 1;
				s_bg = 4'd5;
				
				en_freq = 1;
				s_freq = 3'd4;
				
				res_disp_timer = 0;
				
				if (disp_timer_pulse)
					next_state = FAIL_SCREEN;
				else
					next_state = FAIL_BLUE;
			end
						
			FAIL_SCREEN: begin	
				en_bg = 1;
				s_bg  = 4'd6;
				
				if (enter_pressed)
					next_state = WAIT_SCREEN;
				else
					next_state = FAIL_SCREEN;
			end
			
			WIN_SCREEN: begin
				en_bg = 1;
				s_bg  = 4'd7;
				
				if (enter_pressed)
					next_state = WAIT_SCREEN;
				else
					next_state = WIN_SCREEN;
			end
			
			default: begin
				next_state = INIT_SYSTEM;
			end
		
		endcase
	
	end

endmodule
