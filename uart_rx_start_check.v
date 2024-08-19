module uart_rx_start_check (input strt_chk_en,sampled_bit,CLK,RST,
                            output reg strt_glitch);

always@(posedge CLK, negedge RST)
  begin
    if(!RST)
      begin
        strt_glitch<=0;
      end
    else
      begin
        strt_glitch<=(strt_chk_en&&(sampled_bit!=0))? 1:0;
      end
  end
endmodule