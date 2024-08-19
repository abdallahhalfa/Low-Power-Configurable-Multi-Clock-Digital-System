`timescale 1ns/1ps
module SYS_TOP_tb  ; 

parameter WIDTH  = 8 ;
parameter DEPTH  = 4 ;
parameter NUM_STAGES  = 2 ; 
  reg    RX_IN   ; 
  reg    RST   ; 
  reg    UART_CLK   ; 
  reg    REF_CLK   ; 
  wire    TX_OUT   ; 
  SYS_TOP    #( NUM_STAGES, WIDTH , DEPTH )
   DUT  ( 
       .RX_IN (RX_IN ) ,
      .RST (RST ) ,
      .UART_CLK (UART_CLK ) ,
      .REF_CLK (REF_CLK ) ,
      .TX_OUT (TX_OUT ) ); 
      
reg TX_CLK;
parameter UART_CLK_1 = 271.267;
parameter REF_CLK_1 = 20.0;
parameter TX_CLK_1 = 8680.544;
parameter prescale = 32;

always #(UART_CLK_1/2) UART_CLK=~UART_CLK;
always #(REF_CLK_1/2) REF_CLK=~REF_CLK;
always #(TX_CLK_1/2) TX_CLK=~TX_CLK;

integer i = 0 ;
integer k = 0;

task initialize ;
begin
	UART_CLK = 0;
	REF_CLK = 0;
	TX_CLK = 0;
	RX_IN = 1;
	RST=1;
end
endtask

task reset ;
begin
	#REF_CLK_1
	RST = 0;
	#REF_CLK_1
	RST = 1;
	#REF_CLK_1;
end
endtask

task StrtBit ;
begin
	for (i = 0 ; i < prescale ; i = i+1)
	begin
		RX_IN = 1'b0 ;
		#(UART_CLK_1);
	end
end
endtask

task ParCh ;
input [7:0] data ;
input Par_Type;
reg Par;
begin
 Par = Par_Type ? ~(^(data)) : ^(data);
for (i = 0 ; i < prescale ; i = i+1)
	begin
		RX_IN = Par ;
		#(UART_CLK_1);
	end
end
endtask

task StoptBit ;
begin
	for (i = 0 ; i < prescale ; i = i+1)
	begin
		RX_IN = 1'b1 ;
		#(UART_CLK_1);
	end
end
endtask

task DATAIn ;
input [7:0] inputD ;
begin
for (k = 0 ; k < 8 ; k = k+1)
		begin
			RX_IN = inputD [k] ;
				for (i = 0 ; i < prescale ; i = i +1)
					begin
								#(UART_CLK_1);
					end
		end
end
endtask

task WaitTx ;
begin
	for (i = 0 ; i < 15 ; i = i +1)
		begin
			#(TX_CLK_1);
		end
end
endtask

initial
  begin
    initialize();
    reset();
    #(3*REF_CLK_1)
    /*StrtBit();
    DATAIn(8'haa);
    ParCh(8'haa,1'b0);
    StoptBit();
    
    StrtBit();
    DATAIn(8'h05);
    ParCh(8'h05,1'b0);
    StoptBit();
    
    StrtBit();
    DATAIn(8'h07);
    ParCh(8'h07,1'b0);
    StoptBit();
    
    StrtBit();
    DATAIn(8'hbb);
    ParCh(8'hbb,1'b0);
    StoptBit();
    
    StrtBit();
    DATAIn(8'h05);
    ParCh(8'h05,1'b0);
    StoptBit();*/
    
    StrtBit();
    DATAIn(8'hcc);
    ParCh(8'hcc,1'b0);
    StoptBit();
    
    StrtBit();
    DATAIn(8'h05);
    ParCh(8'h05,1'b0);
    StoptBit();
    
    StrtBit();
    DATAIn(8'h07);
    ParCh(8'h07,1'b0);
    StoptBit();
    
    StrtBit();
    DATAIn(8'h06);
    ParCh(8'h06,1'b0);
    StoptBit();
    
    StrtBit();
    DATAIn(8'hdd);
    ParCh(8'hdd,1'b0);
    StoptBit();
    
    StrtBit();
    DATAIn(8'h04);
    ParCh(8'h04,1'b0);
    StoptBit();
    
    WaitTx();
    WaitTx();
    WaitTx();
    WaitTx();
    WaitTx();
    $stop;
  end


endmodule

