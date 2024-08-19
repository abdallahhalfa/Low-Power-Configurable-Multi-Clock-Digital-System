module FIFO_MEM_CNTRL #(parameter WIDTH=8,DEPTH=3)( input [WIDTH-1:0] wdata,
                                                    input wclken,wclk,
                                                    input [DEPTH-1:0] waddr,raddr,
                                                    output [WIDTH-1:0] rdata
                                                  );

reg [WIDTH-1:0] FIFO_MEM [0:2**DEPTH-1];

                                        
always@(posedge wclk)
  begin
    if(wclken)
      begin
        FIFO_MEM[waddr]<=wdata;
      end
  end
  
assign rdata=FIFO_MEM[raddr];

endmodule