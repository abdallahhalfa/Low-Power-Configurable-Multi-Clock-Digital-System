module uart_rx_data_sampler ( input [5:0] prescale,edge_cnt,
                                             input R_IN,CLK,RST,dat_samp_en,
                                             output sampled_bit);
reg [2:0] sampled,sampled_comp;                                             

always@(*)
  begin
    sampled_comp=sampled;
    if(dat_samp_en)
      begin
        case(edge_cnt)
          prescale/2-2:
            begin
              sampled_comp[0]=R_IN;
            end
          prescale/2-1:
            begin
              sampled_comp[1]=R_IN;
            end
          prescale/2:
            begin
              sampled_comp[2]=R_IN;
            end
          default
            sampled_comp=sampled;
        endcase
      end
    else
      sampled_comp=sampled;
  end
always@(posedge CLK, negedge RST)
  begin
    if(!RST)
      sampled<=0;
    else
      sampled<=sampled_comp;
  end
assign sampled_bit= sampled[0]&sampled[1]|sampled[2]&sampled[1]|sampled[0]&sampled[2];
endmodule                                             
  
