// Our sixth Verilog circuit where we figure out how to handle a
// sum greater than one, which in binary, means more than one digit.
// Our answer is to add a second operation that detects an overflow,
// and sends a signal in a separate output -- the carry flag.
// To detect an overflow, we perform an AND operation on the two
// input bits. If both of them are 1, the carry flag will be set.
// If not, the carry flag will remain clear.

// Here is a truth table for the whole operation, which is
// commonly known as a half adder.

module half_add_with_carry(a, b, y, c);
  input a;
  input b;
  output y;
  output c;
  
  assign y = a + b;
  assign c = a & b;
endmodule
