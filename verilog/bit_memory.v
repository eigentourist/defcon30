module bit_memory(clk, clk_div2, clk_div4, clk_div8, out1, out2, out3);
input clk;
reg test0, test1, test2, test3;
output clk_div2, clk_div4, clk_div8;
output out1, out2, out3;

initial begin
  clk_div2 = 0;
  clk_div4 = 0;
  clk_div8 = 0;
  test0 = 1'b1;
  test1 = 1'b0;
  test2 = 1'b0;
  test3 = 1'b0;
  out1 = 0;
  out2 = 0;
  out3 = 0;
end
 
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
    test3 <= test2;
    test2 <= test1;
    test1 <= test0;
    test0 <= ~test0;
  end
  
  assign out1 = test1;
  assign out2 = test2;
  assign out3 = test3;
   
endmodule