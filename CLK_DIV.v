module CLK_DIV ( input i_ref_clk,i_rst_n,i_clk_en,
                 input [7:0] i_div_ratio,
                 output reg o_div_clk
                 );
wire ClK_DIV_EN; 
wire is_even;
wire [7:0] i_div_ratio_div_2;
reg [4:0] even_count;
reg o_div_clk_seq;
reg odd_flag;               
always@(posedge i_ref_clk, negedge i_rst_n)
  begin
    if(!i_rst_n)
      begin
        o_div_clk_seq<=0;
        even_count<=0;
        odd_flag<=0;
      end
    else if(ClK_DIV_EN)
      begin
        if(is_even)
          begin
            if(~(even_count!=i_div_ratio_div_2-1))
              begin
                o_div_clk_seq<=~o_div_clk_seq;
                even_count<=0;
              end
            else
              even_count<=even_count+1;
          end
        else
          begin
            if(~odd_flag)
              begin
                if(~(even_count!=i_div_ratio_div_2))
                  begin
                    o_div_clk_seq<=~o_div_clk_seq;
                    even_count<=0;
                    odd_flag<=1;
                  end
                else
                  even_count<=even_count+1;
              end
            else
              begin
                if(~(even_count!=i_div_ratio_div_2-1))
                  begin
                    o_div_clk_seq<=~o_div_clk_seq;
                    even_count<=0;
                    odd_flag<=0;
                  end
                else
                  even_count<=even_count+1;
              end            
          end
      end
  end
always@(*)
  begin
    if(!i_rst_n)
      o_div_clk=0;
    else
      o_div_clk = ClK_DIV_EN? o_div_clk_seq:i_ref_clk;
  end
assign i_div_ratio_div_2 = is_even? (i_div_ratio>>1): (i_div_ratio-1)>>1;             
assign ClK_DIV_EN = i_clk_en && ( i_div_ratio != 0) && ( i_div_ratio != 1);
assign is_even = i_div_ratio[0]? 0:1;               
endmodule                  