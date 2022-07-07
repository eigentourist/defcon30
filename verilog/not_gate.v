// Our third Verilog circuit.
// This code performs a logical NOT operation
// on a single 1-bit input port (a) and sends the
// output to the port y.

module not_gate(a, y);
  input a;
  output y;
  
  assign y = ~a;
endmodule