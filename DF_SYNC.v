module DF_SYNC #(parameter N = 4)( input CLKB,RST,
                                   input [N-1:0] A_IN,
                                   output reg [N-1:0] B_IN
                                   );

reg [N-1:0] A_IN_REG;

always@(posedge CLKB, negedge RST)
  begin
    if(!RST)
      begin
        A_IN_REG<=0;
        B_IN<=0;
      end
    else
      begin
        A_IN_REG<=A_IN;
        B_IN<=A_IN_REG;
      end  
  end
endmodule