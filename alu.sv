/************************************************************************************************
 ***                                                                                          ***
 *** ECE 526L Experiment #8                                          Luis A Chavez, Fall 2016 ***
 ***                                                                                          ***
 *** Experiment #8, Arithmetic-Logic Unit Modeling                                            ***
 ***                                                                                          ***
 ************************************************************************************************
 *** Filename: alu.sv                        Created by Luis A Chavez, on November 15th, 2016 ***
 ***                                                                                          ***
 *** Module implementing an Arithmetic-Logic unit                                             ***
 ***                                                                                          *** 
 ************************************************************************************************/

`timescale 1ns/1ns

module alu #(parameter WIDTH = 8)
            (output reg [WIDTH-1:0] ALU_OUT,
	     output reg CF,OF,SF,ZF,
	     input [3:0] OPCODE,
	     input [WIDTH-1:0] A,B,
	     input CLK,EN,OE);
   
   // Reg variable to drive output
   reg [WIDTH :0]  OUTPUT;
   
   localparam
     ADDOP = 4'b0010,
     SUBOP = 4'b0011,
     ANDOP = 4'b0100,
     OROP = 4'b0101,
     XOROP = 4'b0110,
     NOTAOP = 4'b0111;
always_comb begin
   if(OE) ALU_OUT <= OUTPUT[WIDTH-1:0];
   else ALU_OUT <= 'bz;
  end
     
always_ff @(posedge CLK) begin 
   if(EN)begin
      case(OPCODE)
	ADDOP: begin
	   OUTPUT = A + B; 
	   CF <= OUTPUT[WIDTH];
	   
	   if(OUTPUT[WIDTH-1] != A[WIDTH-1] && OUTPUT[WIDTH-1] != B[WIDTH-1])
	     OF <= 1'b1;
	   else OF <= 1'b0;

	   SF <= ALU_OUT[7];
	   ZF <= ~(|ALU_OUT);
	end // ADDOP

	SUBOP: begin
	   OUTPUT = A +((~B)+1);
	   CF <= A < B; // We must borrow if A is less than A.
	   if(OUTPUT[WIDTH-1] != A[WIDTH-1] && OUTPUT[WIDTH-1] != B[WIDTH-1])
	     OF <= 1'b1;
	   else OF <= 1'b0;

	   SF <= ALU_OUT[7];
	   ZF <= ~(|ALU_OUT);
	end // SUBOP
	
	ANDOP: begin
	   OUTPUT = A & B;
	   CF <= 1'b0;
	   OF <= 1'b0;
	   SF <= ALU_OUT[7];
	   ZF <= ~(|ALU_OUT);
	end // ANDOP

	OROP: begin
	   OUTPUT = A | B;
	   CF <= 1'b0;
	   OF <= 1'b0;
	   SF <= ALU_OUT[7];
	   ZF <= ~(|ALU_OUT);
	end // OROP

	XOROP: begin
	   OUTPUT = A ^ B;
	   CF <= 1'b0;
	   OF <= 1'b0;
	   SF <= ALU_OUT[7];
	   ZF <= ~(|ALU_OUT);
	end //XOROP

	NOTAOP: begin
	   OUTPUT = ~A;
	   CF <= 1'b0;
	   OF <= 1'b0;
	   SF <= ALU_OUT[7];
	   ZF <= ~(|ALU_OUT);
	end // NOTAOP
   
	default: begin
	   OUTPUT = ALU_OUT;
	   CF <= 1'b0;
	   OF <= 1'b0;
	   SF <= 1'b0;
	   ZF <= 1'b0;
	end
      endcase // case (OPCODE)
   end //if(EN)
   
   else
    OUTPUT <= OUTPUT;
end
   
endmodule // alu
