module RST_SYNC #(parameter NUM_STAGES = 2) ( input RST,CLK,
                                              output SYNC_RST
                                             );
reg [NUM_STAGES-1:0] Q;
always@(posedge CLK,negedge RST)
  begin
    if(!RST)
      begin
        Q<=0;
      end
    else
      begin
        Q<={Q[NUM_STAGES-2:0],1'b1};
      end
  end
assign SYNC_RST = Q[NUM_STAGES-1];
endmodule  