/*********************************************************************************************
 ***                                                                                       ***
 *** ECE 526L Experiment #4                                       Luis A Chavez, Fall 2016 ***
 ***                                                                                       ***
 *** Experiment #4 Behavioral Modeling of a Counter                                        ***
 ***                                                                                       ***
 *********************************************************************************************    
 *** Filename: counter.sv                   Created by Luis A Chavez, September 30th, 2016 ***
 ***                                                                                       ***
 *** Module implementing a six bit counter                                                 ***
 *********************************************************************************************/

`timescale 1 ns/ 1ns

module counter(COUNT,DATA,CLOCK,RESET,ENABLE,LOAD);
   //Port declarations
   parameter SIZE = 5;
   output reg [SIZE-1:0] COUNT;
   input [SIZE-1:0] 	    DATA;
   input 	    CLOCK,RESET,ENABLE,LOAD;

   always_ff @(posedge CLOCK, negedge RESET)
     if(!RESET) COUNT = 'b0;
     else if(ENABLE) begin
	if(LOAD) COUNT = DATA;
	else  COUNT = COUNT + 1;
     end
endmodule // counter
