/************************************************************************************************
 ***                                                                                          ***
 *** ECE 526L Experiment #9                                          Luis A Chavez, Fall 2016 ***
 ***                                                                                          ***
 *** Experiment #9, Sequence Controller                                                       ***
 ***                                                                                          ***
 ************************************************************************************************
 *** Filename: sequencecontroller.sv         Created by Luis A Chavez, on December 8th, 2016  ***
 ***                                                                                          ***
 *** Module implementing a Sequence controller.                                               ***
 ***     i) This sequence controller takes in an address, opcode, phase, ALU flag, and I_bit  ***
 ***     ii) All of these inputs are obtained from the ROM's instruction register.            ***
 ***     iii) This controller has four phases:                                                ***
 ***               Cycle 0, Fectch: An instruction is fetched from ROM via the instruction    ***
 ***                                register.                                                 ***
 ***               Cycle 1, Decode: The opcode field of the instruction register will be      ***
 ***                                decoded to tell the controller what the operation is      ***
 ***                                and what bits to set.                                     ***
 ***               Cycle 2, Execute: In this stage, if the operation decoded was a load       ***
 ***                                 or store, the appropriate registers will be activated    ***
 ***                                 according to the address indicated by the address        ***
 ***                                 field.                                                   ***
 ***               Cycle 3, Update: The program counter will be updated to                    ***
 ***                                point at the next intruction if there is no branch        ***
 ***                                instruction. If there is a branch instruction, the        *** 
 ***                                type of branch will be decoded, and the branch address    ***
 ***                                will be loaded onto the PC.                               ***
 ***                                                                                          ***
 ***     iv) Each phase will be controller by a phase generator                               ***  
 ***                                                                                          *** 
 ************************************************************************************************/

module sequencecontroller(IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN,PC_LOAD,ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS,ADDR,OPCODE,PHASE,ALU_FLAGS, I_FLAG);

   output reg  IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN,
		 PC_LOAD,ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS;
   input [6:0] 				  ADDR;
   input [3:0] 				  OPCODE;
   input [3:0] 				  ALU_FLAGS;
   input 				  I_FLAG;
   import phasepackage::*;
   input                                  STATE PHASE;
   
   bit [0:0] LDR; // Flag for load
   bit [0:0] STR;  // Flag for store
   bit [0:0] BRANCH; // Flag for when a branch is needed  
   
   localparam
     LOADOP = 4'b0000,
     STOREOP = 4'b0001,
     ADDOP = 4'b0010,
     SUBOP = 4'b0011,
     ANDOP = 4'b0100,
     OROP = 4'b0101,
     XOROP = 4'b0110,
     NOTOP = 4'b0111,
     B = 4'b1000,
     BZ = 4'b1001,
     BN = 4'b1010,
     BV = 4'b1011,
     BC = 4'b1100;
   
   //All signals are active high, except for RAM_CS
   // ALU_flags are in the following order [OF,SF,ZF,CF]
  always_comb begin
     case(PHASE)
       FETCH : {IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN,
		    PC_LOAD,ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS} = 13'b1000000000100; //RAM will be activated by default to drive the memory bus.
       DECODE: begin
	  case(OPCODE)
	    LOADOP: begin
	       LDR = 1'b1;
	       IR_EN = 1'b0;
	    end
	    STOREOP: begin
	       STR = 1'b1;
	       IR_EN = 1'b0;
	    end
	    ADDOP: {IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN,
		    PC_LOAD,ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS} = 13'b0000000011000;
	    SUBOP:  {IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN,
		    PC_LOAD,ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS} = 13'b0000000011000;
	    ANDOP:  {IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN,
		    PC_LOAD,ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS} = 13'b0000000011000;
	    OROP:  {IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN,
		    PC_LOAD,ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS} = 13'b0000000011000;
	    XOROP:  {IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN,
		    PC_LOAD,ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS} = 13'b0000000011000;
	    NOTOP:  {IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN,
		    PC_LOAD,ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS} = 13'b0000000011000;
	    B: begin
	       BRANCH = 1'b1;
	       IR_EN = 1'b0;
	    end
	    BZ: begin
	       IR_EN = 1'b0;
	       if(ALU_FLAGS[1]) BRANCH = 1'b1;
	       else BRANCH = 1'b0;
	    end //BZ
	    BN: begin
	       IR_EN = 1'b0;
	       if(ALU_FLAGS[2]) BRANCH = 1'b1;
	       else BRANCH = 1'b0;
	    end // BN
	    BV: begin
	       IR_EN = 1'b0;
	       if(ALU_FLAGS[3]) BRANCH = 1'b1;
	       else BRANCH = 1'b0;
	    end //BV
	    BC: begin
	       IR_EN = 1'b0;
	       if(ALU_FLAGS[0]) BRANCH = 1'b1;
	       else BRANCH = 1'b0;
	    end //BC
	    default: {IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN, PC_LOAD,ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS} = 13'b0000000000100;//RAM will stay driving memory bus
	  endcase // case (OPCODE)
       end // case: DECODE
       
       EXECUTE: begin
	  if (LDR) begin //First we'll check if we're loading.
	     LDR = 1'b0; // Clear load flag first. 
	     if (ADDR == 64) begin//Instruction is to load register A
		//Immidiate
		if(I_FLAG)  {IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN,PC_LOAD,ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS} =13'b0100000000000;
		//Direct
		else  {IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN,PC_LOAD,ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS} = 13'b0100000000110;
	     end //if(ADDR == 64)
	     
	    else if(ADDR == 65) begin// Instruction is to load register B.
		//Immediate?
		if(I_FLAG)  {IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN, PC_LOAD,ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS} = 13'b0010000000000;
		// Direct 
		else {IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN, PC_LOAD,ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS} = 13'b0010000000110;
	     end //if(ADDR == 65)
	     
	     else if(ADDR == 66) begin 
		if(I_FLAG){IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN, PC_LOAD,ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS} = 13'b0001000000000; // Instruction is to load port direction register.
		else {IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN, PC_LOAD,ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS} = 13'b0001000000100;
	     end
	     
	     //Instruction is to load the IO port, thus PORT_EN must be activated.
	     else if(ADDR == 67) begin
		//Immediate
		if(I_FLAG) {IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN, PC_LOAD,ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS} = 13'b0000100000000;
		//Direct
		else {IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN, PC_LOAD,ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS} = 13'b0000100000110;
	     end // else if(ADDR == 67)
	     else ; //illegal address for load
	  end //if(LDR)
	  else LDR = 1'b0;
	  
 	  if(STR) begin //Else, we're storing
	     STR = 1'b0;
	     if(ADDR == 67) {IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN, PC_LOAD,ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS} = 13'b0000010000000;//IO port is to be stored.
	     else if(ADDR> 32 || ADDR <64){IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN, PC_LOAD,ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS} = 13'b0000000011000;// otherwise, we're storing the output of the ALU
	     else ;
	  end //if(STR)
	  else STR = 1'b0;
       end //EXECUTE

       UPDATE:
	 //Was there a branch instruction?
	 if(BRANCH) {IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN, PC_LOAD,ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS} = 13'b0000001100000;
         else {IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN, PC_LOAD,ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS} = 13'b0000001000100;
     endcase // case (PHASE)
  end // always_comb
endmodule // sequencecontroller
