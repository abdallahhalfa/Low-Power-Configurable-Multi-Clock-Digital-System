module uart_rx_deserializer ( input sampled_bit,deser_en,CLK,RST,
                              input [3:0] bit_cnt,
                              output reg [7:0] P_DATA);

always@(posedge CLK, negedge RST)
  begin
    if(!RST)
      begin
        P_DATA<=0;
      end
    else if(deser_en)
      begin
        if(bit_cnt!=10)
          begin
            P_DATA<={sampled_bit,P_DATA[7:1]};
          end
      end
  end
endmodule