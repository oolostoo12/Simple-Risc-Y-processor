`timescale 1ns/1ns

module IOPORT #(parameter SIZE = 8)
               (inout wire [SIZE -1:0] IO_PORT,
		input [SIZE - 1:0] PORT_DATA, 
		input [0:0] PORT_DIR,
		input [0:0] PORT_RD);

   // Drive the output of port data register to the IO
   assign IO_PORT = (PORT_DIR && !PORT_RD) ? PORT_DATA : 'bz;
   
endmodule // IOPORT


    