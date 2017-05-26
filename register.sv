`timescale 1ns/1ns

module register #(parameter SIZE = 8)
                 (output reg [SIZE -1:0] OUT,
		  input [SIZE-1:0] IN,
		  input CLK,EN);
   
   always_ff @(posedge CLK) begin
      if(EN) OUT <= IN;
      else ;
   end
endmodule // register
