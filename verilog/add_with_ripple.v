// Our eighth Verilog circuit where we connect two adders into
// a ripple adder, allowing us to add two-digit binary numbers.

module add_with_carry(a, b, y, c_in, c_out);
  input a;
  input b;
  input c_in;
  output y;
  output c_out;
  
  wire w1;
  wire w2;
  wire w3;
  
  assign w1 = a ^ b;
  assign w2 = w1 & c_in;
  assign w3 = a & b;
  
  assign y = w1 ^ c_in;
  assign c_out = w2 | w3;
endmodule


// Next, we declare two full adders in a cascading sequence.
// The first adder in the sequence has no carry input, so we
// set its carry input to zero.

module ripple_adder(a, b, y);
  input [1:0] a;
  input [1:0] b;
  output [2:0] y;
  
  wire [2:0] c;
  wire [1:0] sum;
  
  
  add_with_carry adder_1
  (
    .a(a[0]),
    .b(b[0]),
    .c_in(c[0]),
    .y(sum[0]),
    .c_out(c[1])
  );
  
  add_with_carry adder_2
  (
    .a(a[1]),
    .b(b[1]),
    .c_in(c[1]),
    .y(sum[1]),
    .c_out(c[2])
  );
  
  assign y = {c[2], sum};
endmodule
