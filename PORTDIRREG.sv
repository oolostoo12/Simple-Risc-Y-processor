`timescale 1ns/1ns

module PORTDIRREG(output reg [0:0] DIR,
		  input DATA,PDR_EN,CLK,RESET);

   always_ff @(posedge CLK, negedge RESET)begin
      if(!RESET) DIR <= 1'b0;
      else if(PDR_EN) DIR <= DATA;
      else ;
   end
endmodule // PORTDIRREG
