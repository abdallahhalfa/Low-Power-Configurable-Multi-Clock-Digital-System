module ASYNC_FIFO_TOP #(parameter WIDTH=8,DEPTH=3)( input winc,wclk,wrst_n,
                                                        input rinc,rclk,rrst_n,
                                                        input [WIDTH-1:0] wdata,
                                                        output wfull,rempty,
                                                        output [WIDTH-1:0] rdata
                                                       );
wire [DEPTH-1:0] waddr,raddr;
wire [DEPTH:0] wptr,rptr,wq2_rptr,rq2_wptr;
wire wclken;
assign wclken = winc&!wfull;
                                                       
FIFO_MEM_CNTRL #( .WIDTH(WIDTH),.DEPTH(DEPTH)) FIFO_MEM(  .wdata(wdata),
                                                          .wclken(wclken),
                                                          .wclk(wclk),
                                                          .waddr(waddr),
                                                          .raddr(raddr),
                                                          .rdata(rdata)
                                                        );                                                        
FIFO_RD #(.N(DEPTH+1)) RD (  .rinc(rinc),
                             .rclk(rclk),
                             .rrst_n(rrst_n),
                             .rq2_wptr(rq2_wptr),
                             .raddr(raddr),
                             .rptr(rptr),
                             .rempty(rempty)
                           );
                       
FIFO_WR #(.N(DEPTH+1)) WR (  .wclk(wclk),
                             .winc(winc),
                             .wrst_n(wrst_n),
                             .wq2_rptr(wq2_rptr),
                             .waddr(waddr),
                             .wptr(wptr),
                             .wfull(wfull)
                           );
DF_SYNC #(.N(DEPTH+1)) SYNC_r2w (  .CLKB(wclk),
                                   .RST(wrst_n),
                                   .A_IN(rptr),
                                   .B_IN(wq2_rptr)
                                 );                           
                           
DF_SYNC #(.N(DEPTH+1)) SYNC_w2r (  .CLKB(rclk),
                                   .RST(rrst_n),
                                   .A_IN(wptr),
                                   .B_IN(rq2_wptr)
                                 );                        
                       
endmodule