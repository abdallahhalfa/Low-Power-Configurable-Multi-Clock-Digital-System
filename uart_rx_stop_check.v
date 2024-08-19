module uart_rx_stop_check ( input stp_chk_en,sampled_bit,CLK,RST,
                            output reg stp_err);
                            
always@(posedge CLK, negedge RST)
  begin
    if(!RST)
      begin
        stp_err<=0;
      end
    else
      begin
        if(stp_chk_en)
          stp_err<=(sampled_bit!=1)? 1:0;
      end
  end
endmodule