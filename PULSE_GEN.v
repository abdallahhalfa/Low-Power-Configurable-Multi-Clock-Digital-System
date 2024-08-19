module PULSE_GEN ( input CLK,RST,LVL_SIG,
                   output PULSE_SIG
                  );
                  
reg Q;
                  
always@(posedge CLK,negedge RST)
  begin
    if(!RST)
      begin
        Q<=0;
      end
    else
      begin
        Q<=LVL_SIG;
      end
  end
assign PULSE_SIG = (!RST)? 0:(~Q & LVL_SIG); 

endmodule