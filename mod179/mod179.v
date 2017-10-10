module mod179(
	input wire 	  clk,
	input wire 	  reset,
	input wire [15:0] x,
	input wire 	  start,
	output reg 	  done,
	output reg [7:0]  z);
   
   localparam [2:0] load     = 3'b000,
     compute1 = 3'b001,
     inner    = 3'b010,
     compute2 = 3'b011,
     outer    = 3'b100,
     adj      = 3'b101;
   
   reg [15:0] 		  q, nextq;
   reg [15:0] 		  r, nextr;
   reg [ 2:0] 		  state, nextstate;
   
   wire [15:0] 		  mul;
   
   always @(posedge clk, posedge reset)
     begin
	q     <= reset ? 16'b0 : nextq;
	r     <= reset ? 16'b0 : nextr;
	state <= reset ? load  : nextstate;
     end
   
   assign mul = q[7:0] * 8'd77;
   
   always @*
     begin
	nextq     = q;
	nextr     = r;
	nextstate = state;
	done       = 1'd0;
	z          = 8'd0;
	case (state)
	  
	  load:
	    if (start) begin
	       nextq     = x[15:8];
	       nextr     = x[7:0];
	       nextstate = compute1;
            end
	  
	  compute1: 
	    begin
	       nextr     = r + mul[7:0];
	       nextq     = mul[15:8];
	       nextstate = inner;
	    end
	  
	  inner:
	    if (q != 16'd0)
	      nextstate = compute1;
	    else
	      nextstate = compute2;
	  
	  compute2:
	    begin
	       nextq     = r[15:8];
	       nextr     = r[7:0];
	       nextstate = outer;
	    end
	  
	  outer:
	    if (q != 16'd0)
	      nextstate = compute1;
	    else
	      nextstate = adj;
	  
	  adj:
	    begin
	       done = 1'd1;
	       z = (r >= 8'd179) ? (r - 8'd179) : r;
	       nextstate = load;
	    end
	  
	  default:
	    nextstate = load;
	  
	endcase
     end
   
endmodule
