module uart_rx_parity_check ( input par_chk_en,PAR_TYP,sampled_bit,CLK,RST,
                              input [7:0] P_DATA,
                              output reg par_err);
reg parity_comp;
always @(*)
  begin
    if(par_chk_en)
      begin
        if(PAR_TYP)
          begin
            parity_comp=~^P_DATA;
          end
        else
          parity_comp=^P_DATA;
      end
    else
      parity_comp=0;
  end
always@(posedge CLK, negedge RST)
  begin
    if(!RST)
      begin
        par_err<=0;
      end
    else if(par_chk_en)
      begin
        par_err<=(sampled_bit!=parity_comp)? 1:0;
      end
  end 
endmodule
