/*********************************************************************************************
 ***                                                                                       ***
 *** ECE 526L Experiment #7                                       Luis A Chavez, Fall 2016 ***
 ***                                                                                       ***
 *** Experiment #7, Register File Models                                                   ***
 ***                                                                                       ***
 *********************************************************************************************
 *** Filename: regfile.sv                  Created by Luis A Chavez, on November 16th,2016 ***
 ***                                                                                       ***
 *** Module implementing a 32 by 8 register file memory module                             ***
 ***                                                                                       ***
 *********************************************************************************************/


`timescale 1ns/1ns

module regfile #(parameter WIDTH = 8, DEPTH = 5)
                ( inout wire [WIDTH -1:0] DATA_BUS,
		  input [DEPTH - 1 : 0] ADDRESS_BUS,
		  input CS, OE,WS);

   // By default, this reg file has an 8-bit data bus and a 5-bit address bus
   // Therefore, that means it has 2^5 addressable locations, thus needing
   // an array holding 2^5 things of size of 8 bits. A reg variable is needed to
   // hold the data and drive the data bus

   reg [(WIDTH-1):0] DATA_REG, MEMORY[2**DEPTH];

   // Two always blocks will be needed, one to check the single bit
   // input signals and the other to check the posedge of WS.

   assign DATA_BUS = (OE && !CS) ? DATA_REG: 8'bz; //as long as OE is high, block read
   always_ff @(posedge WS) begin //write
      if(!OE && !CS)
	MEMORY[ADDRESS_BUS] <= DATA_BUS;
      else if (CS) //Ignore WS
	MEMORY[ADDRESS_BUS] <= MEMORY[ADDRESS_BUS];
   end // always_ff
   always_comb
     DATA_REG = MEMORY[ADDRESS_BUS];
endmodule // regfile



