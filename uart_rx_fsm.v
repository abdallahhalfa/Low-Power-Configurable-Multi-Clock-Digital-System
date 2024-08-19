module uart_rx_fsm ( input CLK,RST,R_IN,par_err,strt_glitch,stp_err,PAR_EN,
                                               input [5:0] edge_cnt,prescale,
                                               input [3:0] bit_cnt,
                                               output reg deser_en,DATA_VALID,enable,dat_samp_en,par_chk_en,strt_chk_en,stp_chk_en );
localparam IDLE=3'b000,
            START=3'b001,
            DATA=3'b010,
            PARITY=3'b011,
            STOP=3'b100,
            DATA_NEXT=3'b101;
reg [2:0] next_state,current_state;
reg DATA_VALID_comp;
always@(posedge CLK, negedge RST)
  begin
    if(!RST)
      begin
        current_state<=IDLE;
        DATA_VALID<=0;
      end
    else
      begin
        current_state<=next_state;
        DATA_VALID<=DATA_VALID_comp;
      end
  end
always@(*)
  begin
    next_state=IDLE;
    enable=0;
    dat_samp_en=0;
    par_chk_en=0;
    strt_chk_en=0;
    stp_chk_en=0;
    DATA_VALID_comp=0;
    deser_en=0;
    case(current_state)
      IDLE:
        begin
          if(R_IN!=0)
            begin
              next_state=IDLE;
            end
          else
            begin
              next_state=START;
            end
        end
      START:
        begin
          enable=1;
          dat_samp_en=1;
          if(bit_cnt==0&&edge_cnt==prescale-2)
            begin
              strt_chk_en=1;
              next_state=START;
            end
          else if(edge_cnt==prescale-1)
            begin
              if(strt_glitch)
                begin
                  next_state=IDLE;
                  strt_chk_en=0;
                  enable=0;
                end
              else
                begin
                  next_state=DATA;
                  strt_chk_en=0;
                end
            end
          else
            begin
              next_state=START;
            end
        end
      DATA:
        begin
          enable=1;
          dat_samp_en=1;
          deser_en=(edge_cnt==prescale-1)? 1:0;
          if(~(bit_cnt==8&&edge_cnt==prescale-1))
            begin
              next_state=DATA;
            end
          else
            begin
              if(PAR_EN)
                begin
                  next_state=PARITY;
                  
                end
              else
                begin
                  next_state=STOP;
                 
                end
            end
        end
      PARITY:
        begin
          enable=1;
          dat_samp_en=1;
          if(bit_cnt!=10&&edge_cnt==prescale-2)
            begin
              par_chk_en=1;
              next_state=PARITY;
            end
          else if(edge_cnt==prescale-1)
            begin
               next_state=STOP;
               par_chk_en=0;  
            end
          else
            next_state=PARITY;
        end
      STOP:
        begin
          enable=1;
          dat_samp_en=1;
          if(PAR_EN)
            begin
              if(bit_cnt!=11&&edge_cnt==prescale-2)
                begin
                  stp_chk_en=1;
                  next_state=STOP;
                end
              else if (edge_cnt==prescale-1)
                begin
                  next_state=START;
                  stp_chk_en=0;
                  DATA_VALID_comp=~(par_err||stp_err)? 1:0;
                end
              else
                next_state=STOP;
            end
          else
            begin
              if(bit_cnt!=10&&edge_cnt==prescale-2)
                begin
                  stp_chk_en=1;
                  next_state=STOP;
                end
              else if (edge_cnt==prescale-1)
                begin
                  next_state=START;
                  stp_chk_en=0;
                  DATA_VALID_comp=~(stp_err)? 1:0;
                end
              else
                 next_state=STOP;
            end
        end
      //DATA_NEXT:
//        begin
//          enable=1;
//          dat_samp_en=1;
//          if(edge_cnt==prescale/2+2)
//            begin
//              strt_chk_en=1;
//              next_state=DATA_NEXT;
//            end
//          else if (edge_cnt==prescale-1)
//            begin
//            if(strt_glitch)
//                begin
//                  next_state=IDLE;
//                  strt_chk_en=0;
//                  enable=0;
//                end
//              else
//                begin
//                  next_state=DATA;
//                  strt_chk_en=0;
//                end
//            end
//          else
//            begin
//              next_state=DATA_NEXT;
//            end
//        end
      default:
        begin
          next_state=IDLE;
          enable=0;
          dat_samp_en=0;
          par_chk_en=0;
          strt_chk_en=0;
          stp_chk_en=0;
          DATA_VALID_comp=0;
          deser_en=0;
        end
    endcase
  end
endmodule