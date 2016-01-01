module Stimulation(
  clk,
  reset,
  coil,
  rfid_data,
  rfid_info,
  temp_data,
  flame,
  distance1_data,
  distance2_data,
  IR_data,
  SW,
  state, // DEBUG
  LED // DEBUG
);

input clk;
input reset;
input [31:0] rfid_data;

input [15:0] rfid_info;
input [7:0]  temp_data;
input        flame;
input [19:0] distance1_data;
input [19:0] distance2_data;
input [7:0]  IR_data;
input [4:0]  SW;
output [4:0] coil;
output LED;
output [7:0] state; //DEBUG

reg LED;
reg next_LED;

reg [31:0] targetRfidData;
reg [31:0] next_targetRfidData;
reg [4:0] coil;
reg [4:0] next_coil;

reg [7:0] last_temp_data;
reg [7:0] next_last_temp_data;

reg       last_flame;
reg       last2_flame;

reg [31:0] last_rfid_data;
reg [31:0] next_last_rfid_data;

reg [9:0] delay;
reg [9:0] next_delay;

reg [8:0] state;
reg [8:0] next_state;

parameter target = 32'hC4243351;
parameter DELAY_TIME = 10'd1;

always @ (*) begin
  // DEBUG
  next_targetRfidData = target;
//  if (rfid_data == targetRfidData) begin
//    next_LED = 1'b1;
//  end
//  else begin
//    next_LED = 1'b0;
//  end
end

always @ (*) begin
  next_state = state;
  next_coil  = coil;
  next_delay = delay;
  
  case(state)
    8'd0: begin
//      if (rfid_data == targetRfidData)
//        next_state = 8'd1;
      
      next_state = 8'd0;
      
      // Trigger by RFID
      if (rfid_info[0] == 1'b1) begin
        
        if (rfid_info[1] == 1'b1)
          next_state = 8'd1;
        else if (rfid_info[2] == 1'b1)
          next_state = 8'd2;
        else if (rfid_info[3] == 1'b1)
          next_state = 8'd3;
        else if (rfid_info[4] == 1'b1)
          next_state = 8'd4;
        else if (rfid_info[5] == 1'b1)
          next_state = 8'd5;
      end
      
      // Trigger by flame
      if (last_flame == 1'b1 && last2_flame == 1'b1)begin
        //next_LED = 
        next_state = 8'd3;
      end
      
      // Trigger by SW
      if (SW[0] == 1'b1)
        next_state = 8'd1;
      else if (SW[1] == 1'b1)
        next_state = 8'd2;
      else if (SW[2] == 1'b1)
        next_state = 8'd3;
      else if (SW[3] == 1'b1)
        next_state = 8'd4;
      else if (SW[4] == 1'b1)
        next_state = 8'd5;
        
        
      // Trigger by remote
      if (IR_data == 8'h04 || IR_data == 8'h14)
        next_state = 8'd1;
      else if (IR_data == 8'h06 || IR_data == 8'h18)
        next_state = 8'd2;
      else if (IR_data == 8'h02)
        next_state = 8'd3;
      else if (IR_data == 8'h08)
        next_state = 8'd4;
      else if (IR_data == 8'h05)
        next_state = 8'd5;
      
      if (next_state == 8'd0)
        next_coil = 5'b11111;
        
    end
    8'd1: begin
      next_delay = 10'd0;
      next_coil[0] = 1'b0;
      next_state = 8'd6;
    end
    8'd2: begin
      next_delay = 10'd0;
      next_coil[1] = 1'b0;
      next_state = 8'd7;
    end
    8'd3: begin
      next_delay = 10'd0;
      next_coil[2] = 1'b0;
      next_state = 8'd8;
    end
    8'd4: begin
      next_delay = 10'd0;
      next_coil[3] = 1'b0;
      next_state = 8'd9;
    end
    8'd5: begin
      next_delay = 10'd0;
      next_coil[4] = 1'b0;
      next_state = 8'd10;
    end
    8'd6: begin
      next_delay = delay + 10'd1;
      if (delay > DELAY_TIME) begin
        //next_coil[0] = 1'b1;
        next_state = 8'd0;
      end
      else begin
        next_coil[0] = 1'b0;
        next_state = 8'd6;
      end
    end
    8'd7: begin
      next_delay = delay + 10'd1;
      if (delay > DELAY_TIME) begin
        //next_coil[1] = 1'b1;
        next_state = 8'd0;
      end
      else begin
        next_coil[1] = 1'b0;
        next_state = 8'd7;
      end
    end
    8'd8: begin
      next_delay = delay + 10'd1;
      if (delay > DELAY_TIME) begin
        //next_coil[2] = 1'b1;
        next_state = 8'd0;
      end
      else begin
        next_coil[2] = 1'b0;
        next_state = 8'd8;
      end
    end
    8'd9: begin
      next_delay = delay + 10'd1;
      if (delay > DELAY_TIME) begin
        //next_coil[3] = 1'b1;
        next_state = 8'd0;
      end
      else begin
        next_coil[3] = 1'b0;
        next_state = 8'd9;
      end
    end
    8'd10: begin
      next_delay = delay + 10'd1;
      if (delay > DELAY_TIME) begin
        //next_coil[4] = 1'b1;
        next_state = 8'd0;
      end
      else begin
        next_coil[4] = 1'b0;
        next_state = 8'd10;
      end
    end
    
  endcase
//  
//  next_coil[0] = 1'b1;
//  next_coil[1] = 1'b1;
//  next_coil[2] = 1'b1;
//  next_coil[3] = 1'b1;
//  next_coil[4] = 1'b1;
//  next_count = count;
//  // Temperature
//  if ( (last_temp_data - temp_data) < 8'd5 || (temp_data - last_temp_data) < 8'd5) begin
//    if (temp_data > 8'd45)
//      next_coil[1] = 1'b0;
//  end
//  // Specific RFID card
//  if (rfid_data == targetRfidData) begin
//    if (rfid_data == last_rfid_data) begin
//      if (count < 5'd10) begin
//        next_coil[0] = 1'b0;
//        next_count = count + 5'd1;
//      end
//    end
//    else begin
//      next_coil[0] = 1'b0;
//      next_count = 5'd0;
//    end    
//  end
//  // Switch manual turn on stimulations
//  if (SW[0] == 1'b1)
//    next_coil[0] = 1'b0;
//  if (SW[1] == 1'b1)
//    next_coil[1] = 1'b0;
//  if (SW[2] == 1'b1)
//    next_coil[2] = 1'b0;
//  if (SW[3] == 1'b1)
//    next_coil[3] = 1'b0;
//  if (SW[4] == 1'b1)
//    next_coil[4] = 1'b0;
//   
//  next_last_rfid_data = rfid_data;
//  next_last_temp_data = temp_data;
end

always @ (posedge clk or negedge reset) begin
  if(reset == 0) begin
    state          <= 8'd0;
    targetRfidData <= target;
    LED            <= 1'b0;
    coil[0]        <= 1'b1;
    coil[1]        <= 1'b1;
    coil[2]        <= 1'b1;
    coil[3]        <= 1'b1;
    coil[4]        <= 1'b1;
    last_temp_data <= 8'd0;
    last_rfid_data <= 32'b0;
    delay          <= 10'd0;
    last_flame     <= 1'b0;
    last2_flame    <= 1'b0;
  end
  else begin
    state          <= next_state;
    targetRfidData <= next_targetRfidData;
    LED            <= flame;//next_LED;
    coil[0]        <= next_coil[0];
    coil[1]        <= next_coil[1];
    coil[2]        <= next_coil[2];
    coil[3]        <= next_coil[3];
    coil[4]        <= next_coil[4];
    last_temp_data <= next_last_temp_data;
    last_rfid_data <= next_last_rfid_data;
    delay          <= next_delay;
    last_flame     <= flame;
    last2_flame    <= last_flame;
  end
end

endmodule