`timescale 1ns/100ps
module aasd(output reg AASD_RESET,
	    input CLK, RST);
   reg 		      D;
   
always_ff @(posedge CLK, negedge RST) begin
   if(!RST) begin
      D <= 1'b0;
      AASD_RESET <= 1'b0;
   end
   else begin
      D <=1'b1;
      AASD_RESET <= D;
   end
end
 endmodule // aasd
