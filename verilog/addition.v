// Our fifth Verilog circuit where we start doing computation!
// This module demonstrates a fundamental truth about computing
// with bits (simple binary digits) -- how do you make a digital
// circuit that can add numbers when the output is a wire that
// can only hold low voltage (zero) or high voltage (one) ?

module add_one(a, b, y);
  input a;
  input b;
  output y;
  
  assign y = a + b;
endmodule
