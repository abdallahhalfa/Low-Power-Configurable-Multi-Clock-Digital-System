module parity_calc#(parameter data_width=3)( input Data_valid,par_typ,CLK,RST,
                                             input [2**data_width-1:0] p_data,
                                             output reg par_bit
                                             );
//reg par_bit_next;
//always@(*)
//  begin
//    if(Data_valid)
//      par_bit_next=(par_typ)? (~^p_data):(^p_data);
//    else
//      par_bit_next=0;
//  end

always@(posedge CLK, negedge RST)
  begin
    if(!RST)
      par_bit<=0;
    else if(Data_valid)
      par_bit<=(par_typ)? (~^p_data):(^p_data);
  end
endmodule

