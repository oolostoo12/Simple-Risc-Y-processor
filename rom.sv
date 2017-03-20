`timescale 1ns/1ns

module rom #(parameter WIDTH = 8, DEPTH = 5)
            (output reg [WIDTH-1:0] DATA_BUS,
	     input  [DEPTH-1:0] ADDRESS_BUS,
	     input CS,OE);
   
   reg [WIDTH -1 : 0] MEMORY[2**DEPTH];
   
   always_comb begin
     if(OE && !CS)
     DATA_BUS = MEMORY[ADDRESS_BUS];
      else if(CS) 
	DATA_BUS = 'bz;
     else ;
   end
   
endmodule // rom
