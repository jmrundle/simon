module ROM_320x240 (
   input                clk,    			
   input          [8:0] x,
   input          [7:0] y,  
   output   reg   [2:0] dout
   );
   
   parameter IMAGE_FILE = "black.mem";
   
   wire [16:0] addr  = 320*y + x;
   
   reg [2:0] mem [0:76799];
   initial $readmemh(IMAGE_FILE, mem);

   always @(posedge clk)
      dout <= mem[addr];
   
endmodule