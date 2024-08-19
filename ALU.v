module ALU #(parameter WIDTH=8)( input CLK,RST,enable,
                                 input [WIDTH-1:0] A,B,
                                 input [3:0] ALU_FUN,
                                 output reg OUT_VALID,
                                 output reg [2*WIDTH-1:0] ALU_OUT
                                 );
                                 
reg [WIDTH-1:0] ALU_OUT_COMP;
wire OUT_VALID_comp;                                
always@(posedge CLK, negedge RST)
  begin
    if(!RST)
      begin
        ALU_OUT<=0;
      end
    else if(enable)
      begin
        ALU_OUT<=ALU_OUT_COMP;
      end
  end 
  
always@(posedge CLK, negedge RST)
  begin
    if(!RST)
      begin
        OUT_VALID<=0;
      end
    else 
      OUT_VALID<=OUT_VALID_comp;
  end 
    
always@(*)
  begin
    if(!RST)
      begin
        ALU_OUT_COMP=0;
      end
    else if(enable)
      begin
        case(ALU_FUN)
          4'b0000:
            begin
              ALU_OUT_COMP=A+B;
            end
          4'b0001:
            begin
              ALU_OUT_COMP=A-B;
            end
          4'b0010:
            begin
              ALU_OUT_COMP=A*B;
            end
          4'b0011:
            begin
              ALU_OUT_COMP=A/B;
            end
          4'b0100:
            begin
              ALU_OUT_COMP=A&B;
            end
          4'b0101:
            begin
              ALU_OUT_COMP=A|B;
            end
          4'b0110:
            begin
              ALU_OUT_COMP=~(A&B);
            end
          4'b0111:
            begin
              ALU_OUT_COMP=~(A|B);
            end
          4'b1000:
            begin
              ALU_OUT_COMP=A^B;
            end
          4'b1001:
            begin
              ALU_OUT_COMP=~(A&B);
            end
          4'b1010:
            begin
              ALU_OUT_COMP=(A==B);
            end
          4'b1011:
            begin
              ALU_OUT_COMP=(A>B);
            end
          4'b1100:
            begin
              ALU_OUT_COMP=A>>1;
            end
          4'b1101:
            begin
              ALU_OUT_COMP=A<<1;
            end
          default:
            begin
              ALU_OUT_COMP=0;
            end
        endcase
      end
    else
      ALU_OUT_COMP=0;
  end
assign OUT_VALID_comp = (enable);


endmodule