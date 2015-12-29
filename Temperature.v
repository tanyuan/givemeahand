module Temperature(
  clk,
  trigger,
  temp_inout,
  temp_data_out
);

input clk;
input trigger;
inout temp_inout;

output [7:0] temp_data_out;

reg last_trigger;

reg  next_temp_inout;
wire w_next_temp_inout;
reg  last_temp_inout;


reg temp_start;
reg next_temp_start;
reg temp_reading;
reg next_temp_reading;
reg [19:0]temp_count;
reg [19:0]next_temp_count;
reg [2:0] temp_state;
reg [2:0] next_temp_state;
reg [5:0] temp_bit_count;
reg [5:0] next_temp_bit_count;
reg [41:0] pre_data;
reg [41:0] next_pre_data;
reg [41:0] temp_data;
reg [41:0] next_temp_data;

assign temp_data_out = temp_data[23:16];

assign temp_inout = (temp_reading == 1'b0)? next_temp_inout : 1'bz;

always @(*) begin
//temp_o  = temp_inout;
  if(trigger == 1'b0 && last_trigger == 1'b1)
    next_temp_start = 1'b1;
  else
    next_temp_start = temp_start;
  
  //if(SW[1] == 1'b1)
    //LEDR = 18'b0;
  
  if(temp_start == 1'b1)begin
    case(temp_state)
    3'b000:begin//reset
            next_temp_count = 20'b0;
            next_temp_state = 3'b001;
            next_pre_data = 42'b0;
            next_temp_data = temp_data;
            next_temp_bit_count = 6'b0;
            next_temp_reading = 1'b0;
            next_temp_inout = 1'b0;
          end
    3'b001:begin//20ms @0
            next_pre_data = 42'b0;
            next_temp_data = temp_data;
            next_temp_bit_count = 6'b0;
            if(temp_count < 20'd1000000)begin
              next_temp_count = temp_count + 20'b1;
              next_temp_inout = 1'b0;
              next_temp_state = temp_state;
              next_temp_reading = 1'b0;
            end
            else begin
              next_temp_count = 20'b0;
              next_temp_inout = 1'bz;
              next_temp_state = 3'b101;
              next_temp_reading = 1'b1;
            end
          end
    3'b010:begin//40us @1
            next_pre_data = 42'b0;
            next_temp_data = temp_data;
            next_temp_bit_count = 6'b0;
            next_temp_reading = 1'b0;
            if(temp_count < 20'd2000)begin
              next_temp_count = temp_count + 20'b1;
              next_temp_inout = 1'b1;
              next_temp_state = temp_state;
            end
            else begin
              next_temp_count = 20'b0;
              next_temp_inout = 1'b1;
              next_temp_state = 3'b011;
            end
          end
    3'b011:begin//50us @0
            next_pre_data = 42'b0;
            next_temp_data = temp_data;
            next_temp_bit_count = 6'b0;
            next_temp_reading = 1'b0;
            if(temp_count < 20'd2500)begin
              next_temp_count = temp_count + 20'b1;
              next_temp_inout = 1'b0;
              next_temp_state = temp_state;
            end
            else begin
              next_temp_count = 20'b0;
              next_temp_inout = 1'b1;
              next_temp_state = 3'b100;
            end
          end
    3'b100:begin//wait for data @1
            next_pre_data = 42'b0;
            next_temp_data = temp_data;
            next_temp_bit_count = 6'b0;
            next_temp_count = 20'b0;
            next_temp_reading = 1'b0;
            next_temp_inout = 1'bz;
            if(temp_inout != 1'b0)begin
              next_temp_state = temp_state;
            end
            else begin
              next_temp_state = 3'b101;
            end
          end
    3'b101:begin//read data
            next_pre_data = pre_data;
            next_temp_data = temp_data;
            next_temp_bit_count = temp_bit_count;
            next_temp_inout = 1'bz;
            //temp_o = temp_inout;
            if (temp_count > 20'd9000)begin
              next_temp_reading = temp_reading;
              next_temp_count = temp_count;
              next_temp_start = 1'b0;
              next_temp_state = 3'b111;
            end
            else if(temp_inout == 1'b1)begin
              next_temp_reading = 1'b1;
              next_temp_count = temp_count + 20'b1;
              next_temp_state = temp_state;
            end
            else if(last_temp_inout == 1'b1 && temp_inout == 1'b0)begin
              next_temp_reading = temp_reading;
              next_temp_count = temp_count;
              next_temp_state = 3'b110;
            end
            else begin
              next_temp_reading = temp_reading;
              next_temp_count = temp_count;
              next_temp_state = temp_state;
            end
          end
    3'b110:begin//read data
            next_pre_data = pre_data;
            next_temp_data = temp_data;
            next_temp_reading = 1'b1;
            next_temp_inout = 1'bz;
            //LEDR = temp_count[19:2];
            //if(temp_bit_count == 6'd5)
              //LEDR = temp_count[17:0];
            
            
            if(temp_bit_count < 6'd41)begin //LEDR[0] = 1'b1;
              if(temp_count <= 20'd3000)begin //LEDR[1] = 1'b1;
                //LEDR = temp_count[17:0];
                next_pre_data[6'd41-temp_bit_count] = 1'b0;
                //temp_o = 1'b0;
                next_temp_bit_count = temp_bit_count + 6'b1;
                next_temp_count = 20'b0;
                next_temp_state = 3'b101;
              end
              else begin//if(temp_count >= 20'd5000 && temp_count <= 20'd8000)begin 
              //LEDR[2] = 1'b1;
                next_pre_data[6'd41-temp_bit_count] = 1'b1;
                //temp_o = 1'b1;
                next_temp_bit_count = temp_bit_count + 6'b1;
                next_temp_count = 20'b0;
                next_temp_state = 3'b101;
              end
//              else begin LEDR[3] = 1'b1;
//                //LEDR = temp_count[17:0];
//                next_pre_data = pre_data;
//                next_temp_bit_count = 6'b0;
//                next_temp_count = 20'b0;
//                next_temp_state = 3'b111;
//              end
            end
            else begin  //LEDR[4] = 1'b1;
              next_pre_data = pre_data;
              next_temp_bit_count = 6'b0;
              next_temp_count = 20'b0;
              next_temp_state = 3'b111;
            end
          end
    3'b111:begin
            next_temp_inout = 1'bz;
            next_pre_data = pre_data;
            next_temp_data = pre_data;
            next_temp_bit_count = 6'b0;
            next_temp_count = 20'b0;
            next_temp_reading = 1'b0;
            next_temp_state = 3'b000;
            next_temp_start = 1'b0;
            //LEDR = pre_data;
          end
    default:begin 
            next_temp_inout = 1'bz;
            next_pre_data = pre_data;
            next_temp_data = temp_data;
            next_temp_bit_count = 6'b0;
            next_temp_reading = 1'b0;
            next_temp_count = 20'b0;
            next_temp_state = 3'b000;
          end
    endcase
  end
  else begin 
    next_temp_inout = 1'bz;
    next_pre_data = pre_data;
    next_temp_data = temp_data;
    next_temp_bit_count = 6'b0;
    next_temp_count = 20'b0;
    next_temp_state = 3'b000;
  end
end
  
//=== sequential part ================================
always @(posedge clk) begin

  last_trigger   <= trigger;
  
  temp_start     <= next_temp_start;
  last_temp_inout<= temp_inout;
  pre_data       <= next_pre_data;
  temp_data      <= next_temp_data;
  temp_bit_count <= next_temp_bit_count;
  temp_reading   <= next_temp_reading;
  temp_count     <= next_temp_count;
  temp_state     <= next_temp_state;

end

endmodule