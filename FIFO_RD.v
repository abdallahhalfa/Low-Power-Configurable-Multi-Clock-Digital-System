module FIFO_RD #(parameter N=4)( input rinc,rclk,rrst_n,
                                 input [N-1:0] rq2_wptr,
                                 output reg [N-2:0] raddr,
                                 output reg [N-1:0] rptr,
                                 output rempty
                                 );
integer i;
reg [N-1:0] rptr_bin;
always@(posedge rclk,negedge rrst_n)
  begin
    if(!rrst_n)
      begin
        raddr<=0;
        rptr_bin<=0;
      end
    else if(!rempty&rinc)
      begin
        raddr<=raddr+1;
        rptr_bin<=rptr_bin+1;
      end
  end                                              
always@(*)
  begin
    if(!rrst_n)
      begin
        rptr=0;
      end
    else
      begin
        for(i=0;i<N-1;i=i+1)
          begin
            rptr[i]=rptr_bin[i+1]^rptr_bin[i];
          end
        rptr[N-1]=rptr_bin[N-1];
      end
  end 
  
assign rempty = (!rrst_n)? 1:(rptr == rq2_wptr);  

endmodule
