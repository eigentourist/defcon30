// Our seventh Verilog circuit where we turn our half adder into a
// full adder, which can be used as a building block for circuits
// that can add larger numbers. This circuit has an input carry bit
// as well as an output carry bit. The process goes as follows:
//
// First, we add the two incoming bits, a and b. Notice that we are
// using an XOR rather than a simple '+' for the addition. This is
// a cleaner way to create this circuit: we rely on normal operations
// rather than overflow behavior.
//
// Next, we take the sum and perform an AND with the incoming carry bit.
// This creates the first of two temporary results we need in order to
// handle addition with carry. If either this result or the next result
// are true, then we know our addition still involves a carry operation.
//
// After this, we AND the two incoming bits a and b together. This gives
// us the second temporary result.
//
// Our final output is an addition of the sum of the inputs a and b with
// the incoming carry bit. The last detail is an OR operation on our
// two temporary results, w2 and w3. If either of these is true, then
// our output carry bit will be set, moving the carry operation forward
// into the next adder if we are part of an array of adder circuits.
// 
// Here is a truth table for the whole thing:
//
// a | b | c_in | y | c_out
// ------------------------
// 0 | 0 |   0  | 0 |   0
// 1 | 0 |   0  | 1 |   0
// 0 | 1 |   0  | 1 |   0
// 1 | 1 |   0  | 0 |   1
// 0 | 0 |   1  | 1 |   0
// 1 | 0 |   1  | 0 |   1
// 0 | 1 |   1  | 0 |   1
// 1 | 1 |   1  | 1 |   1

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
