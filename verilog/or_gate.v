// Our second Verilog circuit.
// This code performs a logical OR operation
// on two 1-bit input ports (a and b) and sends the
// output to the port y.

module or_gate(a, b, y);
  input a;
  input b;
  output y;
  
  assign y = a | b;
endmodule