module ReadFromReg(
  //basic
  clk,
  reset,
  //control
  start,
  done, 
  //input
  addr,
  //output data
  data,
  //SPI
  MISO,
  MOSI,
  SCK,
  SDA

);
//==== in/out declaration ==================================
    //-------- input ---------------------------------------
	input clk;
	input reset;
	input start;
	
	input [7:0] addr;
	input MISO;
	
    //-------- output -------------------------------------- 
    output [7:0] data;

	output SCK;
	output SDA;
	output MOSI;
	output done;
	
//==== reg/wire declaration ================================
    //-------- output --------------------------------------	
	reg SCK;
	reg SDA;
	reg MOSI;
	reg done;
	reg [7:0] data;
	
	reg SCK_w;	
	reg SDA_w;
    reg MOSI_w;	
	reg done_w;
	reg [7:0] data_w;
	
    //-------- flip-flops ----------------------------------
	
	reg [3:0] state;
	reg [3:0] count;
	
	reg [3:0] state_w;
	reg [3:0] count_w;
	//--------- wire ---------------------------------------
	
	wire [7:0] formalAddr;
	
//==== combinational part ==================================	

   assign formalAddr = ( (addr<<1)&8'h7E ) | 8'h80; 	
	
always @(*) begin
  state_w    = state;
  count_w    = count;
  
  SCK_w      = SCK;
  SDA_w      = SDA;
  MOSI_w     = MOSI;
  done_w     = done;
  data_w     = data;
  
  
    case(state) 
	  4'd0: begin		
	    if(start == 1'b1) begin
	      SDA_w      = 1'b0;
			MOSI_w = formalAddr[3'd7 - count];
		   state_w    = 4'd1;
		end
	  end
	  4'd1: begin
	  if(count != 4'd8) begin
		  SCK_w = 1'b1;
		  count_w = count + 4'd1;
		  state_w = 4'd2;
	  end
	  else begin
		  //SDA_w = 1'b1;
		  count_w = 4'd0;
		  state_w = 4'd3;
		end
	  end
	  4'd2: begin
	   SCK_w = 1'b0;
		if(count != 4'd8) MOSI_w = formalAddr[3'd7 - count];  //write address to MFRC-522 bit by bit
		state_w = 4'd1;
	  end
	  4'd3: begin
		state_w = 4'd4;
	  end
	  4'd4: begin
	    if(count != 4'd8) begin
		  SCK_w = 1'b1;		  
		  count_w = count + 4'd1;
		  data_w[3'd7 - count] = MISO;
		  state_w = 4'd5;
		end
		else begin
		  SDA_w = 1'b1;		  
		  count_w = 4'd0;
		  state_w = 4'd6;
		end
	  end
	  4'd5: begin
	    SCK_w = 1'b0;
		state_w = 4'd4;
	  end
	  4'd6: begin
        done_w = 1'd1;
		state_w = 4'd7;
	  end	
	  4'd7: begin
	    done_w  = 1'b0;
		state_w = 4'd0;
	  end

	endcase
end

always @ (posedge clk or negedge reset) begin
  if(reset == 0) begin
   SCK      <= 1'b0;
	SDA      <= 1'b1;
	MOSI     <= 1'b0;

	done     <= 1'b0;
	
	state    <= 4'd0;
	count    <= 4'd0;
	data     <= 8'd0;
  
  end
  else begin
    SCK      <= SCK_w;
	SDA      <= SDA_w;
	MOSI     <= MOSI_w;

	done     <= done_w;
	data     <= data_w;
	
	state    <= state_w;
	count    <= count_w;
	
  end
end
endmodule