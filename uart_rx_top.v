module uart_rx_top (input R_IN,PAR_EN,PAR_TYP,CLK,RST,
                    input [5:0] prescale,
                    output data_valid,par_err,stp_err,
                    output [7:0] P_DATA);
wire dat_samp_en,enable,sampled_bit;
wire par_chk_en,strt_chk_en,strt_glitch,stp_chk_en,deser_en;
wire [3:0] bit_cnt;
wire [5:0] edge_cnt;

uart_rx_fsm U1(.CLK(CLK),
               .RST(RST),
               .R_IN(R_IN),
               .par_err(par_err),
               .stp_err(stp_err),
               .strt_glitch(strt_glitch),
               .PAR_EN(PAR_EN),
               .edge_cnt(edge_cnt),
               .prescale(prescale),
               .bit_cnt(bit_cnt),
               .deser_en(deser_en),
               .DATA_VALID(data_valid),
               .enable(enable),
               .dat_samp_en(dat_samp_en),
               .par_chk_en(par_chk_en),
               .strt_chk_en(strt_chk_en),
               .stp_chk_en(stp_chk_en)
               );
               
uart_rx_data_sampler U2 (.CLK(CLK),
                         .RST(RST),
                         .R_IN(R_IN),
                         .dat_samp_en(dat_samp_en),
                         .prescale(prescale),
                         .edge_cnt(edge_cnt),
                         .sampled_bit(sampled_bit)
                         );

uart_rx_deserializer U3 (.CLK(CLK),
                         .RST(RST),
                         .deser_en(deser_en),
                         .sampled_bit(sampled_bit),
                         .bit_cnt(bit_cnt),
                         .P_DATA(P_DATA)
                         );

uart_rx_edge_bit_counter U4 (.CLK(CLK),
                             .RST(RST),
                             .enable(enable),
                             .PAR_EN(PAR_EN),
                             .prescale(prescale),
                             .bit_cnt(bit_cnt),
                             .edge_cnt(edge_cnt)
                             ); 
                             
uart_rx_parity_check U5 (.par_chk_en(par_chk_en),
                         .PAR_TYP(PAR_TYP),
                         .sampled_bit(sampled_bit),
                         .P_DATA(P_DATA),
                         .par_err(par_err),
                         .CLK(CLK),
                         .RST(RST)
                          );


uart_rx_start_check U6 (.strt_chk_en(strt_chk_en),
                        .sampled_bit(sampled_bit),
                        .strt_glitch(strt_glitch),
                        .CLK(CLK),
                        .RST(RST)
                        );

uart_rx_stop_check U7 (.stp_chk_en(stp_chk_en),
                       .sampled_bit(sampled_bit),
                       .stp_err(stp_err),
                       .CLK(CLK),
                        .RST(RST)
                       );

endmodule