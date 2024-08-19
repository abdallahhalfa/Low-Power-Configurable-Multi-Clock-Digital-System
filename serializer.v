module serializer #(parameter data_width=3)( input [2**data_width-1:0] P_DATA,
                                             input Data_valid,ser_en,CLK,RST,busy,
                                             output reg ser_data,ser_done
                                             );
reg [2**data_width-1:0] serial_reg;
integer i;
reg[data_width+1:0] count;
always @(posedge CLK, negedge RST)
  begin
    if(!RST)
      begin
        serial_reg<=0;
        ser_done<=0;
        count<=0;
      end
    else if (Data_valid&&!busy)
      begin
        serial_reg<=P_DATA;
      end
    else if (ser_en)
      begin
        ser_data<=serial_reg[0];
        for(i=0;i<2**data_width-1;i=i+1)
          begin
            serial_reg[i]<=serial_reg[i+1];
          end
        serial_reg[2**data_width-1]<=0;
        if(count==2**data_width-1)
          ser_done<=1;
        else
          ser_done<=0;
        count<=count+1;
      end
  end
endmodule
