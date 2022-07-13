module bit_memory(clk, clk_div2, clk_div4, clk_div8, clk_div16, out1, out2, out3);
input clk;
output clk_div2, clk_div4, clk_div8, clk_div16;
output out1, out2, out3;
reg test0 = 1'b1;
reg test1 = 1'b0;
reg test2 = 1'b0;
reg test3 = 1'b0;

 
  always @ (posedge clk)
  begin
    clk_div2 <= ~clk_div2;
  end
  
  always @ (posedge clk_div2)
  begin
    clk_div4 <= ~clk_div4;
  end
  
  always @ (posedge clk_div4)
  begin
    clk_div8 <= ~clk_div8;
  end

  always @ (posedge clk_div8)
  begin
    test1 <= test0;
    test2 <= test1;
    test3 <= test2;
    clk_div16 <= ~clk_div16;
  end
  
  always @(posedge clk_div16)
  begin
    test0 <= ~test0;
  end
  
  

assign out1 = test1;
assign out2 = test2;
assign out3 = test3;
endmodule