module Distance(
  clk,
  Trig,
  Echo,
  distance
);

input clk;
output Trig;
input Echo;
output distance;

reg        Trig;
reg        next_Trig;
wire       Echo;
reg        last_Echo;

reg [8:0]  trig_count;
reg [8:0]  next_trig_count;
reg        trig_start;
reg        next_trig_start;
reg [19:0] echo_count;
reg [19:0] next_echo_count;

reg [19:0] distance;
reg [19:0] next_distance;

//reg [19:0] distance_out;
//reg [19:0] next_distance_out;

reg  [23:0] clks;
wire [23:0] next_clks;

assign next_clks = clks + 24'd1;

always@(*)begin
  if(trig_start == 1'b1)begin
    if(trig_count <= 9'd498)begin
      next_Trig = 1'b1;
      next_trig_count = trig_count + 9'b1;
      next_trig_start = trig_start;
      end
    else begin
      next_Trig = 1'b0;
      next_trig_count = trig_count;
      next_trig_start = 1'b0;
      end
    end
  else begin
    if(clks[21] == 1'b0 && next_clks[21] == 1'b1)begin//KEY[0] == 1'b1 && last_KEY[0] == 1'b0 )begin
      next_Trig = 1'b0;
      next_trig_count = 9'b0;
      next_trig_start = 1'b1;
      end
    else begin
      next_Trig = 1'b0;
      next_trig_count = 9'b0;
      next_trig_start = trig_start;
      end
  end


end



always@(*)begin
  if(trig_start == 1'b1)begin
    next_echo_count = 20'b0;
    end
  else if(trig_start == 1'b0 && Echo == 1'b1)begin// && last_Echo == 1'b0)begin
    next_echo_count = echo_count + 20'b1;
    end
  else begin
    next_echo_count = echo_count;
    end
    
  if(next_echo_count == echo_count)begin
    next_distance = echo_count*340/1000000;
    end
  else begin
    next_distance = distance;
    end
    
end

//=== sequential part ================================
always @(posedge clk)begin
  clks       <= next_clks;
  Trig       <= next_Trig;
  trig_start <= next_trig_start;
  trig_count <= next_trig_count;
  last_Echo  <= Echo;
  echo_count <= next_echo_count;
  distance   <= next_distance;  
end

endmodule