module uart_fsm#(parameter data_width=3)( input Data_valid,ser_done,par_en,RST,CLK,
                 output reg ser_en,busy,
                 output reg [1:0] mux_sel
                );
localparam IDLE=3'b000,
           START=3'b001,
           DATA=3'b010,
           PARITY=3'b011,
           STOP=3'b100;
reg [2:0] state,state_next;
always@(*)
  begin
    state_next=IDLE;
    ser_en=0;
    mux_sel=1;
    busy=0;
    case(state)
      IDLE:
        begin
          if(Data_valid)
            state_next=START;
          else
            state_next=state;
        end
      START:
        begin
          busy=1;
          mux_sel=0;
          ser_en=1;
          state_next=DATA;
        end
      DATA:
        begin
          busy=1;
          mux_sel=2;
          ser_en=1;
          if(ser_done)
            begin
              state_next=(par_en)? PARITY:STOP;
            end
          else
            begin
              state_next=DATA;
            end
        end
      PARITY:
        begin
          busy=1;
          mux_sel=3;
          ser_en=0;
          state_next=STOP;
        end
      STOP:
        begin
          busy=1;
          mux_sel=1;
          state_next=IDLE;
        end
      default:
        begin
          state_next=IDLE;
          ser_en=0;
          mux_sel=0;
          busy=0;
        end 
    endcase
  end


always @(posedge CLK, negedge RST)
  begin
    if(!RST)
      begin
        state<=IDLE;
      end
    else
      begin
        state<=state_next;
      end
  end
endmodule