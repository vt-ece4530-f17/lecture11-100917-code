`timescale 1ns/1ps

module tbmod179;

  reg reset;
  reg clk;
  reg [15:0] x;
  reg start;
  
  wire done;
  wire [7:0] z;
  
  mod179 d1(clk, reset, x, start, done, z);
  
  initial
    begin
	clk   = 1'b0;
	start = 1'b0;
	reset = 1'b0;
	#100
	reset = 1'b1;
	#100
	reset = 1'b0;
	#300
    while (1)
	  begin
	  x     = $random % 65535;
	  $display("%d -> %d", x, x % 179);
	  start = 1'b1;
	  #100
	  start = 1'b0;
	  #3000;
	  end
	end
	
  always
    #50 clk = ~clk;


endmodule