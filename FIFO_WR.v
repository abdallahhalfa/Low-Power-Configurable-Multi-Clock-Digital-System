module FIFO_WR #(parameter N=4) ( input wclk,winc,wrst_n,
                                  input [N-1:0] wq2_rptr,
                                  output reg [N-2:0] waddr,
                                  output reg [N-1:0] wptr,
                                  output wfull
                                 );
integer i;
reg [N-1:0] wptr_bin;
always@(posedge wclk,negedge wrst_n)
  begin
    if(!wrst_n)
      begin
        waddr<=0;
        wptr_bin<=0;
      end
    else if(!wfull&winc)
      begin
        waddr<=waddr+1;
        wptr_bin<=wptr_bin+1;
      end
  end
  
always@(*)
  begin
    if(!wrst_n)
      begin
        wptr=0;
      end
    else
      begin
        for(i=0;i<N-1;i=i+1)
          begin
            wptr[i]=wptr_bin[i+1]^wptr_bin[i];
          end
        wptr[N-1]=wptr_bin[N-1];
      end
  end 
   
assign wfull = (!wrst_n)? 0:((wptr[N-1]!=wq2_rptr[N-1])&&(wptr[N-2]!=wq2_rptr[N-2])&&(wptr[N-3:0]==wq2_rptr[N-3:0]));
  
  
endmodule