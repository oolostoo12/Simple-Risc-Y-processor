/*********************************************************************************************
 ***                                                                                       ***
 *** ECE 526L Experiment #5                                       Luis A Chavez, Fall 2016 ***
 ***                                                                                       ***
 *** Experiment #5 Scalable Multiplexer                                                    ***
 ***                                                                                       ***
 *********************************************************************************************
 *** Filename: scale_mux.sv                 Created by Luis A Chavez, on October 4th, 2016 ***
 ***                                                                                       ***
 *** Module implementing a scalable multiplexer                                            ***
 *********************************************************************************************/

`timescale 1ns/ 1ns

module scale_mux(OUT,A,B,SEL);
   //Port declarations
   parameter SIZE = 1;
   output reg [SIZE - 1 : 0] OUT;
   input [SIZE -1 : 0] 	     A;
   input [SIZE -1 : 0] 	     B;
   input 		     SEL;

   always @(SEL,A,B) begin
      OUT = SEL ? B : A;
   end

endmodule // scale_mux
