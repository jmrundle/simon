module system_de2 (
	input				CLOCK_50,				//	50 MHz
	input	 [0:0]	KEY,
	
	input       AUD_ADCDAT,
	inout       AUD_BCLK,
	inout       AUD_ADCLRCK,
	inout       AUD_DACLRCK,
	inout       I2C_SDAT,
	
	output      AUD_XCK,
	output      AUD_DACDAT,
	output      I2C_SCLK,
	
	output			VGA_CLK,   				//	VGA Clock
	output			VGA_HS,					//	VGA H_SYNC
	output			VGA_VS,					//	VGA V_SYNC
	output			VGA_BLANK,				//	VGA BLANK
	output			VGA_SYNC,				//	VGA SYNC
	output [9:0]	VGA_R,   				//	VGA Red[9:0]
	output [9:0]	VGA_G,	 				//	VGA Green[9:0]
	output [9:0]	VGA_B,	   			//	VGA Blue[9:0]

	inout					PS2_CLK,
	inout					PS2_DAT
	);
	
	// Internal Wires
	wire	[7:0]	ps2_key_data;
	wire			ps2_key_en;
	wire			keycode_ready;
	wire	[7:0]	keycode;
	wire			make;
	
	wire  [8:0]  xvga;
   wire  [7:0]  yvga;
   wire  [2:0]  color;
	wire 	[19:0] half_wav;
	wire 			 audio_res;
	
	wire [4:0] level_01, level_10, max_score_01, max_score_10;
	wire [2:0] bg;
	
	
	processor processor (
		.clk				(CLOCK_50),
		.reset 			(~KEY[0]),
		.keycode 		(keycode),
		.keycode_ready	(keycode_ready),
		.make				(make),
		.level_01 		(level_01),
		.level_10 		(level_10),
		.max_score_01 	(max_score_01),
		.max_score_10 	(max_score_10),
		.bg 				(bg),
		.audio_res		(audio_res),
		.half_wav		(half_wav)
	);	
	
	color_selector color_selector (
		.clk 				(VGA_CLK),
		.xvga 			(xvga),
		.yvga 			(yvga),
		.level_01 		(level_01),
		.level_10 		(level_10),
		.max_score_01 	(max_score_01),
		.max_score_10 	(max_score_10),
		.bg				(bg),
		.color			(color)
	);
	
	// keyboard
	
	PS2_Controller PS2 (
		// Inputs
		.CLOCK_50			(CLOCK_50),
		.reset				(~KEY[0]),

		// Bidirectionals
		.PS2_CLK				(PS2_CLK),
		.PS2_DAT				(PS2_DAT),

		// Outputs
		.received_data		(ps2_key_data),
		.received_data_en	(ps2_key_en)
	);
	
	keycode_recognizer keycode_recognizer (
		.clk					(CLOCK_50),
		.reset_n				(KEY[0]),
		.ps2_key_en			(ps2_key_en),
		.ps2_key_data		(ps2_key_data),
		.keycode				(keycode),
		.make					(make),
		.keycode_ready		(keycode_ready)
	);
	
	
	// VGA display
	
	vga_xy_controller vga_xy_controller (
      .CLOCK_50      (CLOCK_50),
      .resetn        (1'b1),
      .color         (color),
      .x             (xvga),
      .y             (yvga),
      .VGA_R         (VGA_R),
      .VGA_G         (VGA_G),
      .VGA_B         (VGA_B),
      .VGA_HS        (VGA_HS),
      .VGA_VS        (VGA_VS),
      .VGA_BLANK     (VGA_BLANK),
      .VGA_SYNC      (VGA_SYNC),
      .VGA_CLK       (VGA_CLK)				
   );
	
	
	// audio

   wire				   audio_out_allowed;
   wire     [31:0]   osc_out;   

   square_wave_osc osc (
      .CLOCK_50		(CLOCK_50),
		.half_wav		(half_wav),
      .reset			(audio_res),
      .out           (osc_out)
   );

   Audio_Controller Audio_Controller (
      // Inputs
      .CLOCK_50						(CLOCK_50),
      .reset						   (audio_res),
      .left_channel_audio_out		(osc_out),
      .right_channel_audio_out	(osc_out),
      .write_audio_out			   (audio_out_allowed),
      .AUD_ADCDAT					   (AUD_ADCDAT),
      // Bidirectionals
      .AUD_BCLK					   (AUD_BCLK),
      .AUD_ADCLRCK				   (AUD_ADCLRCK),
      .AUD_DACLRCK				   (AUD_DACLRCK),
      // Outputs
      .audio_out_allowed			(audio_out_allowed),
      .AUD_XCK					      (AUD_XCK),
      .AUD_DACDAT					   (AUD_DACDAT)
   );
   
   avconf avc (
      .I2C_SCLK					(I2C_SCLK),
      .I2C_SDAT					(I2C_SDAT),
      .CLOCK_50					(CLOCK_50),
      .reset						(audio_res)
   );
	
endmodule
