module CLK_GATE ( input CLK,CLK_EN,
                  output GATED_CLK
                 );
reg Q;
always@(*)
  begin
    if(!CLK)
      Q = CLK_EN;
  end
assign GATED_CLK = Q & CLK;
endmodule
