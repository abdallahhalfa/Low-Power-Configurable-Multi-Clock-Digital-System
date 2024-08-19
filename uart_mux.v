module uart_mux(input [1:0] mux_sel,
                input par_bit,ser_data,CLK,RST,
                output reg TX_OUT
                );

always@(*)
  begin
    TX_OUT=0;
    case(mux_sel)
      2'b00: TX_OUT=0;
      2'b01: TX_OUT=1;
      2'b10: TX_OUT=ser_data;
      2'b11: TX_OUT=par_bit;
      default:
        TX_OUT=0;
    endcase
  end
endmodule

