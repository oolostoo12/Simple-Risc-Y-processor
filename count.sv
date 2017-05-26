/*********************************************************************************************
 ***                                                                                       ***
 *** ECE 526L Experiment #4                                       Luis A Chavez, Fall 2016 ***
 ***                                                                                       ***
 *** Experiment #4 Behavioral Modeling of a Counter                                        ***
 ***                                                                                       ***
 *********************************************************************************************    
 *** Filename: count.sv                     Created by Luis A Chavez, September 30th, 2016 ***
 ***                                                                                       ***
 *** Top-level model instantiating modules counter.sv and aasd.sv                          ***
 *********************************************************************************************/

`timescale 1ns/ 1ns

  module count(COUNT,DATA,CLOCK,RESET,ENABLE,LOAD);
   //Port Declaration
   output [5:0] COUNT;
   input  [5:0] DATA;
   input 	CLOCK,RESET,ENABLE,LOAD;

   //Internal variables
   wire 	RST;
   
   //instantiating count.sv and aasd.sv
   aasd AASD(RST,RESET,CLOCK);
   counter CNT(COUNT,DATA,CLOCK,RST,ENABLE,LOAD);

endmodule // count
