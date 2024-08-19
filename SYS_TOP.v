module SYS_TOP #(parameter NUM_STAGES = 2, WIDTH = 8,DEPTH=4)( input RX_IN,REF_CLK,UART_CLK,RST,
                                                               output TX_OUT
                                                              );
//UART_RX_SIGNALS
wire [WIDTH-1:0] UART_RX_DATA;
wire UART_RX_DATA_VALID,UART_RX_PAR_ERR,UART_RX_STOP_ERR;
//DATA_SYNC)SIGNALS
wire [WIDTH-1:0] DATA_sync_bus;
wire DATA_SYNC_enable_pulse;
//REG_FILE_SIGNALS
wire WrEn,RdEn,RdData_valid;
wire [DEPTH-1:0] Address;
wire [WIDTH-1:0] WrData;
wire [WIDTH-1:0] RdData;
wire [WIDTH-1:0] REG0,REG1,REG2,REG3;
//ALU_SIGNALS
wire ALU_CLK,ALU_EN,ALU_OUT_VALID;
wire [3:0] ALU_FUN;
wire [2*WIDTH-1:0] ALU_OUT;
//CLOCK_GATE_SIGNALS
wire GATE_EN;
//RST_SYNC_1_SIGNALS
wire SYNC_RST_1;
//FIFO_SIGNALS
wire winc,rinc;
wire [WIDTH-1:0] wdata;
wire wfull,rempty;
wire [WIDTH-1:0] rdata;
//RST_SYNC_2_SIGNALS
wire SYNC_RST_2;
//UART_TX_SIGNALS
wire busy;
//CLKDIV_MUX_SIGNALS
wire [WIDTH-1:0] CLKDIV_MUX_OUT;


uart_rx_top UART_RX ( .R_IN(RX_IN),
                      .PAR_EN(REG2[0]),
                      .PAR_TYP(REG2[1]),
                      .CLK(RX_CLK),
                      .RST(SYNC_RST_2),
                      .prescale(REG2[7:2]),
                      .data_valid(UART_RX_DATA_VALID),
                      .par_err(UART_RX_PAR_ERR),
                      .stp_err(UART_RX_STOP_ERR),
                      .P_DATA(UART_RX_DATA)
                    );

DATA_SYNC #(.NUM_STAGES(NUM_STAGES) ,.WIDTH(WIDTH) ) DATA_SYNC (  .CLK(REF_CLK),/////////////////////
                                                                  .RST(SYNC_RST_1), 
                                                                  .bus_enable(UART_RX_DATA_VALID),
                                                                  .unsync_bus(UART_RX_DATA),
                                                                  .sync_bus(DATA_sync_bus),
                                                                  .enable_pulse(DATA_SYNC_enable_pulse)
                                                                );
                                                         


REG_FILE #(.WIDTH(WIDTH),.DEPTH(DEPTH)) REG_FILE ( .CLK(REF_CLK),
                                                   .RST(SYNC_RST_1),
                                                   .WrEn(WrEn),
                                                   .RdEn(RdEn),
                                                   .Address(Address),
                                                   .WrData(WrData),
                                                   .RdData_valid(RdData_valid),
                                                   .RdData(RdData),
                                                   .REG0(REG0),
                                                   .REG1(REG1),
                                                   .REG2(REG2),
                                                   .REG3(REG3)
                                                  ); 
                                                  
ALU #(.WIDTH(WIDTH)) ALU (     .CLK(ALU_CLK),
                               .RST(SYNC_RST_1),//////////////
                               .enable(ALU_EN),
                               .A(REG0),
                               .B(REG1),
                               .ALU_FUN(ALU_FUN),
                               .OUT_VALID(ALU_OUT_VALID),
                               .ALU_OUT(ALU_OUT)
                          );   

CLK_GATE CLK_GATE(  .CLK(REF_CLK),
                    .CLK_EN(GATE_EN),
                    .GATED_CLK(ALU_CLK)
                  ); 

RST_SYNC #( .NUM_STAGES(NUM_STAGES)) RST_SYNC_1 ( .RST(RST),
                                                  .CLK(REF_CLK),
                                                  .SYNC_RST(SYNC_RST_1)
                                                  );
                                                 
ASYNC_FIFO_TOP #(.WIDTH(WIDTH),.DEPTH(DEPTH-1)) ASYNC_FIFO_TOP ( .winc(winc),
                                                                 .wclk(REF_CLK),
                                                                 .wrst_n(SYNC_RST_1),///////////////////////
                                                                 .rinc(rinc),
                                                                 .rclk(TX_CLK),
                                                                 .rrst_n(SYNC_RST_2),
                                                                 .wdata(wdata),
                                                                 .wfull(wfull),
                                                                 .rempty(rempty),
                                                                 .rdata(rdata)
                                                                );
                                                                
PULSE_GEN PULSE_GEN(  .CLK(TX_CLK),/////////////////
                      .RST(SYNC_RST_2),
                      .LVL_SIG(busy),
                      .PULSE_SIG(rinc)
                  );                                                                                                               
                                                
RST_SYNC #( .NUM_STAGES(NUM_STAGES)) RST_SYNC_2 ( .RST(RST),
                                                  .CLK(UART_CLK),
                                                  .SYNC_RST(SYNC_RST_2)
                                                  ); 
                                                  
uart_top #(.data_width(3)) UART_TX ( .P_DATA(rdata),
                                     .PAR_EN(REG2[0]),
                                     .PAR_TYP(REG2[1]),
                                     .Data_valid(!rempty),
                                     .CLK(TX_CLK),
                                     .RST(SYNC_RST_2),
                                     .TX_OUT(TX_OUT),
                                     .busy(busy)
                                    );                                                  
 
CLK_DIV CLK_DIV_1( .i_ref_clk(UART_CLK),
                   .i_rst_n(SYNC_RST_2),
                   .i_clk_en(1'b1),
                   .i_div_ratio(CLKDIV_MUX_OUT),////////////////
                   .o_div_clk(RX_CLK)
                 );                                                  
                                                  
CLK_DIV CLK_DIV_2( .i_ref_clk(UART_CLK),
                   .i_rst_n(SYNC_RST_2),
                   .i_clk_en(1'b1),////////////////
                   .i_div_ratio(REG3),
                   .o_div_clk(TX_CLK)
                 );                                                                                                       
                                                  
CLKDIV_MUX #(.WIDTH(WIDTH)) CLKDIV_MUX ( .IN(REG2[7:2]),
                                         .OUT(CLKDIV_MUX_OUT)
                                         );                                                  

SYS_CTRL #(.WIDTH(WIDTH),.DEPTH(DEPTH)) SYS_CTRL ( .CLK(REF_CLK),
                                                   .RST(SYNC_RST_1),
                                                   .ALU_OUT(ALU_OUT),
                                                   .OUT_VALID(ALU_OUT_VALID),
                                                   .RD_DATA(RdData),
                                                   .RD_DATA_valid(RdData_valid),
                                                   .RX_P_DATA(DATA_sync_bus),
                                                   .RX_D_VLD(DATA_SYNC_enable_pulse),
                                                   .FIFO_FULL(wfull),
                                                   .ENABLE(ALU_EN),
                                                   .CLK_EN(GATE_EN),
                                                   .ALU_FUN(ALU_FUN),
                                                   .ADDRESS(Address),
                                                   .WrEn(WrEn),
                                                   .RdEn(RdEn),
                                                   .WrData(WrData),
                                                   .TX_P_DATA(wdata),
                                                   .TX_D_VLD(winc)
                                               );

                                                  
endmodule                                                                                                                                                                                                     