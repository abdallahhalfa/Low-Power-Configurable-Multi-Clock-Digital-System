module uart_rx_edge_bit_counter ( input CLK,RST,enable,PAR_EN,
                                  input [5:0] prescale,
                                  output reg [3:0] bit_cnt,
                                  output reg [5:0] edge_cnt);
                                  
always @(posedge CLK, negedge RST)
begin
  if(!RST)
    begin
      edge_cnt<=0;
      bit_cnt<=0;
    end
  else if(enable)
    begin
      if((PAR_EN==0&&bit_cnt>9)||(PAR_EN==1&&bit_cnt>10))
        begin
          bit_cnt<=0;
          edge_cnt<=0;
        end
      else if(edge_cnt!=prescale-1)
        begin
          edge_cnt<=edge_cnt+1;
        end
      else
        begin
          bit_cnt<=bit_cnt+1;
          edge_cnt<=0;
        end  
    end
  else
    begin
      edge_cnt<=0;
      bit_cnt<=0; 
    end    
end
endmodule