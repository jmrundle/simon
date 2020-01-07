module display (
	input [5:0] num,
	output reg [6:0] hexl,
	output reg [6:0] hexr
	);
	
	always @(num)
		case (num)
			6'h0: begin
				hexl = 7'b1000000;
				hexr = 7'b1000000;
			end
			
			6'h1: begin
				hexl = 7'b1000000;
				hexr = 7'b1111001;
			end
			
			6'h2: begin
				hexl = 7'b1000000;
				hexr = 7'b0100100;
			end
			
			6'h3: begin
				hexl = 7'b1000000;
				hexr = 7'b0110000;
			end
			
			6'h4: begin
				hexl = 7'b1000000;
				hexl = 7'b1000000;
				hexr = 7'b0011001;
			end
			
			6'h5: begin
				hexl = 7'b1000000;
				hexr = 7'b0010010;
			end
			
			6'h6: begin
				hexl = 7'b1000000;
				hexr = 7'b0000010;
			end
			
			6'h7: begin
				hexl = 7'b1000000;
				hexr = 7'b1111000;
			end
			
			6'h8: begin
				hexl = 7'b1000000;
				hexr = 7'b0000000;
			end
			
			6'h9: begin
				hexl = 7'b1000000;
				hexr = 7'b0010000;
			end
			
			6'd10: begin
				hexl = 7'b1111001;
				hexr = 7'b1000000;
			end
			
				
			6'd11: begin
				hexl = 7'b1111001;
				hexr = 7'b1111001;
			end
			
			6'd12: begin
				hexl = 7'b1111001;
				hexr = 7'b0100100;
			end
			
			6'd13: begin
				hexl = 7'b1111001;
				hexr = 7'b0110000;
			end
			
			6'd14: begin
				hexl = 7'b1111001;
				hexr = 7'b0011001;
			end
			
			6'd15: begin
				hexl = 7'b1111001;
				hexr = 7'b0010010;
			end
			
			6'd16: begin
				hexl = 7'b1111001;
				hexr = 7'b0000010;
			end
			
			6'd17: begin
				hexl = 7'b1111001;
				hexr = 7'b1111000;
			end
			
			6'd18: begin
				hexl = 7'b1111001;
				hexr = 7'b0000000;
			end
			
			6'd19: begin
				hexl = 7'b1111001;
				hexr = 7'b0010000;
			end
			
		endcase

endmodule
