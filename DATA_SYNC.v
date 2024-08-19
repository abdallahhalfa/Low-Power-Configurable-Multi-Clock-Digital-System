module DATA_SYNC #(parameter NUM_STAGES = 2, WIDTH = 8) ( input CLK, RST, bus_enable,
                                                          input [WIDTH-1:0]  unsync_bus,
                                                          output reg [WIDTH-1:0] sync_bus,
                                                          output reg enable_pulse
                                                         );
reg [NUM_STAGES:0] Q;
wire PULSE_GEN_OUT;
always@(posedge CLK, negedge RST)
  begin
    if(!RST)
      begin
        Q<=0;
      end
    else 
     begin
      Q<={Q[(NUM_STAGES)-1:0],bus_enable};
     end
  end  

always@(posedge CLK, negedge RST)
  begin
    if(!RST)
      begin
        sync_bus<=0;
        enable_pulse<=0;
      end
    else
      begin
        sync_bus<=(PULSE_GEN_OUT)? unsync_bus:sync_bus;
        enable_pulse<=PULSE_GEN_OUT;
      end
  end
assign PULSE_GEN_OUT = ~Q[(NUM_STAGES)]&Q[(NUM_STAGES)-1];

endmodule
