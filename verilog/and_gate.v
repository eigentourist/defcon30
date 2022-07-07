// Our first Verilog circuit!
// This code performs a logical AND operation
// on two 1-bit input ports (a and b) and sends the
// output to the port y.

module and_gate(a, b, y);
  input a;
  input b;
  output y;
  
  assign y = a & b;
endmodule