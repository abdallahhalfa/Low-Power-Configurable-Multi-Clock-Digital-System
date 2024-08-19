module REG_FILE #(parameter WIDTH=8, DEPTH=4)( input CLK,RST,
                                               input WrEn,RdEn,
                                               input [DEPTH-1:0] Address,
                                               input [WIDTH-1:0] WrData,
                                               output reg RdData_valid,
                                               output reg [WIDTH-1:0] RdData,
                                               output [WIDTH-1:0] REG0,REG1,REG2,REG3
                                               );

reg [WIDTH-1:0] REGFILE [2**DEPTH-1:0];
integer i;                                              

always@(posedge CLK, negedge RST)
  begin
    if(!RST)
      begin
        for(i=0;i<2**DEPTH;i=i+1)
          begin
            if(i==2)
              REGFILE[i]<='b100000_01;
            else if(i==3)
              REGFILE[i]<='b00100000;
            else
              REGFILE[i]<=0;
          end
          RdData<=0;
	  RdData_valid<=0;
      end
    else if(WrEn&&!RdEn)
      begin
        REGFILE[Address]<=WrData;
      end
    else if(RdEn&&!WrEn)
      begin
        RdData<=REGFILE[Address];
	RdData_valid<=1;
      end
    else
      begin
      	RdData_valid<=0;
      end
  end
  
assign {REG0,REG1,REG2,REG3} = {REGFILE[0],REGFILE[1],REGFILE[2],REGFILE[3]};

endmodule