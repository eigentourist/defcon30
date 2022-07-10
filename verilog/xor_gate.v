// Our fourth Verilog circuit.
// This code performs a logical XOR operation
// on two single 1-bit input ports (a and b) and sends the
// output to the port y.
//
// XOR is shorthand for Exclusive OR. This deserves a bit of detail,
// so here is a truth table to help compare it to a normal OR operation:
//
//  Truth Table for OR versus XOR:
//  Normal OR                 Exclusive OR (XOR)
//  =================         =================
//  A  B  |  A OR B           A  B  |  A XOR B
//  0  0  |    0              0  0  |    0
//  1  0  |    1              1  0  |    1
//  0  1  |    1              0  1  |    1
//  1  1  |    1       ***    1  1  |    0

module xor_gate(a, b, y);
  input a;
  input b;
  output y;
  
  assign y = a ^ b;
endmodule