module seqcont(output IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN,PC_LOAD,ALU_EN,ALU_OE,RAM_OE,RDR_EN,RAM_CS,
	       input [6:0] ADDR,
	       input [3:0] OPCODE,ALU_FLAGS, 
	       input I_FLAG,CLK,RST);

   import phasepackage::*;
   STATE PHASE;
 
   // Internal variable declarations
   wire 	      RESET;
   	      
   // Instantiations
   aasd AASD(RESET,CLK,RST);
   phaser PHASER(PHASE, CLK, RESET,1'b0);
   sequencecontroller SEQUENCECONTROLLER(IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN,PC_LOAD,ALU_EN,ALU_OE,RAM_OE,RDR_EN,RAM_CS,ADDR,OPCODE,PHASE,ALU_FLAGS,I_FLAG);

endmodule // seqcont
