`timescale 1ns/ 100ps
module phaser(PHASE,CLK,RST,EN);

   input CLK,RST,EN;
   import phasepackage::*;
   output STATE PHASE;
   always_ff @(posedge CLK, negedge RST) begin
      if(!RST) PHASE <= FETCH;
      else if(!EN) //Enable is active low
	PHASE <= PHASE.next;
      else
	PHASE <= PHASE;
     end
endmodule // phaser
