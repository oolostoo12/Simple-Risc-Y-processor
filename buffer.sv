`timescale 1ns/1ns

module buffer #(parameter SIZE = 8) 
               (output [SIZE-1:0] OUT,
		input [SIZE-1:0] IN,
		input EN);

   assign OUT = (EN) ?  IN : 'bz;
endmodule // buffer
