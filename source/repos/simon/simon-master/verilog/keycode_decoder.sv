module keycode_decoder (
    input       [7:0]   keycode,
    output reg  [2:0]   code
    );

    always @(keycode) begin
        case (keycode)
            8'h15: code = 3'd0;     // q (green)
            8'h1D: code = 3'd1;     // w (red)
            8'h1C: code = 3'd2;     // a (yellow)
            8'h1B: code = 3'd3;     // s (blue)
            8'h5A: code = 3'd4;     // enter key
            default: code = 3'd5;   // none of the above
        endcase
    end

endmodule
