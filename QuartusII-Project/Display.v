module Display(
  clk,
  reset,
  rfid_info,
  temp_data,
  distance1_data,
  distance2_data,
  coil,
  route_record,
  state,
  LED
);

input clk;
input reset;

input [15:0] rfid_info;
input [7:0] temp_data;
input [19:0] distance1_data;
input [19:0] distance2_data;
input [4:0] coil;
input route_record;
input [7:0] state;

output [11:0] LED;

reg [17:0] LED;
reg [17:0] next_LED;

always @ (*) begin
  next_LED = LED;
  
  //next_LED[12:5] = state; // DEBUG
  
  // Distance1 LED[12:9] //////////////
  // distance1_data in centimeters
  if (distance1_data > 20'd1)
    next_LED[9] = 1'b1;
  else
    next_LED[9] = 1'b0;

  if (distance1_data > 20'd5)
    next_LED[10] = 1'b1;
  else
    next_LED[10] = 1'b0;
    
  if (distance1_data > 20'd10)
    next_LED[11] = 1'b1;
  else
    next_LED[11] = 1'b0;
    
  if (distance1_data > 20'd100)
    next_LED[12] = 1'b1;
  else
    next_LED[12] = 1'b0;
    
  // Distance2 LED[16:13] //////////////
  // distance2_data in centimeters
  if (distance2_data > 20'd1)
    next_LED[13] = 1'b1;
  else
    next_LED[13] = 1'b0;

  if (distance2_data > 20'd5)
    next_LED[14] = 1'b1;
  else
    next_LED[14] = 1'b0;
    
  if (distance2_data > 20'd10)
    next_LED[15] = 1'b1;
  else
    next_LED[15] = 1'b0;
    
  if (distance2_data > 20'd100)
    next_LED[16] = 1'b1;
  else
    next_LED[16] = 1'b0;

  // Temperature LED[8:5] ////////////
//  next_LED[7:0] = temp_data;
  if (temp_data > 8'd45)
    next_LED[8] = 1'b1;
  else
    next_LED[8] = 1'b0;
    
  if (temp_data > 8'd35)
    next_LED[7] = 1'b1;
  else
    next_LED[7] = 1'b0;
    
  if (temp_data > 8'd25)
    next_LED[6] = 1'b1;
  else
    next_LED[6] = 1'b0;
  
  if (temp_data > 8'd15)
    next_LED[5] = 1'b1;
  else
    next_LED[5] = 1'b0;
    
  // Coil LED[4:0] ////////////
  if (coil[0] == 1'b0)
    next_LED[0] = 1'b1;
  else
    next_LED[0] = 1'b0;
    
  if (coil[1] == 1'b0)
    next_LED[1] = 1'b1;
  else
    next_LED[1] = 1'b0;
    
  if (coil[2] == 1'b0)
    next_LED[2] = 1'b1;
  else
    next_LED[2] = 1'b0;
    
  if (coil[3] == 1'b0)
    next_LED[3] = 1'b1;
  else
    next_LED[3] = 1'b0;
    
  if (coil[4] == 1'b0)
    next_LED[4] = 1'b1;
  else
    next_LED[4] = 1'b0;
    
end

always @ (posedge clk or negedge reset) begin
  if(reset == 0) begin
    LED <= 18'b0;
  end
  else begin
    LED <= next_LED;
  end
end

endmodule