module uart_top#(parameter data_width=3)( input [2**data_width-1:0] P_DATA,
                                          input PAR_EN,PAR_TYP,Data_valid,CLK,RST,
                                          output TX_OUT,busy
                                          );
wire par_bit,ser_en,ser_done,ser_data;
wire [1:0] mux_sel;

parity_calc #(.data_width(data_width)) u1(.Data_valid(Data_valid),
                                          .p_data(P_DATA),
                                          .par_typ(PAR_TYP),
                                          .CLK(CLK),
                                          .RST(RST),
                                          .par_bit(par_bit)
                                          );
                                          
uart_mux u2 (.mux_sel(mux_sel),
             .par_bit(par_bit),
             .ser_data(ser_data),
             .CLK(CLK),
             .RST(RST),
             .TX_OUT(TX_OUT)
             );
        

uart_fsm #(.data_width(data_width)) u3( .Data_valid(Data_valid),
                                        .ser_done(ser_done),
                                        .par_en(PAR_EN),
                                        .RST(RST),
                                        .CLK(CLK),
                                        .ser_en(ser_en),
                                        .busy(busy),
                                        .mux_sel(mux_sel)
                                        );
                                        
                                                                               
serializer #(.data_width(data_width)) u4( .P_DATA(P_DATA),
                                          .Data_valid(Data_valid),
                                          .ser_en(ser_en),
                                          .CLK(CLK),
                                          .RST(RST),
                                          .ser_data(ser_data),
                                          .ser_done(ser_done),
                                          .busy(busy)
                                          );
                                          
endmodule                                        