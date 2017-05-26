`timescale 1ns/1ns

`include "/home/users5/lac63361/526/lab9/phasepackage.sv"
`include "/home/users5/lac63361/526/lab4/counter.sv"
`include "/home/users5/lac63361/526/lab5/scale_mux.sv"
`include "/home/users5/lac63361/526/lab7/regfile.sv"
`include "/home/users5/lac63361/526/lab7/rom.sv"
`include "/home/users5/lac63361/526/lab8/alu.sv"
`include "/home/users5/lac63361/526/lab9/seqcont.sv"
`include "/home/users5/lac63361/526/lab9/aasd.sv"
`include "/home/users5/lac63361/526/lab9/phaser.sv"
`include "/home/users5/lac63361/526/lab9/sequencecontroller.sv"

module RISCY(inout wire [7:0] IO,
	     input CLK,RST);

   import phasepackage::*;
   STATE PHASE;
  
   //Declaring internal variables
   wire 	   IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN,PC_LOAD,ALU_EN,ALU_OE,RAM_OE,RDR_EN,RAM_CS,DIR;
   wire [3:0] 	   ALU_FLAGS;
   wire [7:0] 	   RAM_DATA;
   wire [7:0] 	   PORT_READ_DATA;
   wire [31:0] 	   ROM_OUT;
   wire [7:0] 	   RAM_OUT;
   wire [4:0] 	   ROM_ADDR;
   wire [31:0] 	   INSTR;
   wire 	   RESET;
   wire [7:0] 	   PORT_DATA;
   wire [7:0] 	   DATA;
   wire [7:0] 	   PORT_DATA_OUT;
   wire [7:0] 	   A;
   wire [7:0] 	   B;
   wire [7:0] 	   ALU_OUT;
   wire [7:0] 	   ALU_OUT1;
   
 	   
   /* Instruction format;
    * OPCODE = INSTR[31:28]
    * I_Flag = INSTR[27]
    * Address = INSTR [26:20]
    * Reserved = [19:8]
    * ROM_Data = [7:0]
    */ 
   //instantiating Modules
   aasd AASD(RESET,CLK,RST); //AASD
   
   rom #(32,5) ROM(ROM_OUT,ROM_ADDR,1'b0,1'b1); //32x32 ROM
   
   counter #(5) PC(ROM_ADDR,INSTR[24:20],CLK,RESET,PC_EN,PC_LOAD); //Program counter
   
   register #(32) MIR(INSTR,ROM_OUT,CLK,IR_EN); //Memory instruction register
   
   regfile RAM(RAM_OUT,INSTR[4:0],RAM_CS,RAM_OE,CLK); //RAM
   
   register #(8) RDR(RAM_DATA,RAM_OUT,CLK,RDR_EN); //Ram data register
   
   PORTDIRREG PDR(DIR,INSTR[0],PDR_EN,CLK,RESET); //Port direction register
   
   register #(8) PORT_DATA_REG(PORT_DATA,DATA,CLK,PORT_EN); //Port data register
   
   buffer #(8) PORTBUFF(PORT_DATA_OUT,PORT_DATA,DIR); //Port direction buffer
   
   IOPORT #(8) IO_PORT(IO, PORT_DATA_OUT, DIR, PORT_RD); //Loading stuff from port data register to the IO
   
   buffer #(8) READBUFF(RAM_OUT,IO,PORT_RD); //Port read buffer, i.e storing IO
 
   register #(8) A_REG(A,DATA,CLK,A_EN); //A register for alu input
   
   register #(8) B_REG(B,DATA,CLK,B_EN); // B register for alu input
   
   alu ALU(ALU_OUT,ALU_FLAGS[0],ALU_FLAGS[3],ALU_FLAGS[2],ALU_FLAGS[1],INSTR[31:28],A,B,CLK,ALU_EN,ALU_OE); //ALU
   
   buffer #(8) ALU_BUF(RAM_OUT,ALU_OUT,ALU_OE); //Buffer between alu output and Ram data bus
   
   scale_mux #(8) MUX(DATA,INSTR[7:0],RAM_DATA,RAM_OE); //Multiplexor

   phaser PHASER(PHASE,CLK,RESET,1'b0);
   
   sequencecontroller SequenceController(IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN,PC_LOAD,ALU_EN,ALU_OE,RAM_OE,RDR_EN,RAM_CS,INSTR[26:20],INSTR[31:28],PHASE,ALU_FLAGS,INSTR[27]);
 
endmodule // RISCY   