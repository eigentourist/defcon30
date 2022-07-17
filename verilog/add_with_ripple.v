// Our eighth Verilog circuit where we connect two adders into
// a ripple adder, allowing us to add two-digit binary numbers.

`include "full_add_with_carry.v"

module ripple_adder
  (
    input [1:0] a,
    input [1:0] b,
    output [2:0] y
  );
  
  wire c1, c2, c3;
  wire [1:0] sum;
  
  assign c1 = 0;
  
  add_with_carry adder_1
  (
    .a(a[0]),
    .b(b[0]),
    .c_in(c1),
    .y(sum[0]),
    .c_out(c2)
  );
  
  add_with_carry adder_2
  (
    .a(a[1]),
    .b(b[1]),
    .c_in(c2),
    .y(sum[1]),
    .c_out(c3)
  );
  
  assign y = {c3, sum};
endmodule
