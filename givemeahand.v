module givemeahand(
  clk,
  IRDA_RXD,
  // RFID reader
  RST,
  MISO,
  MOSI,
  SCK,
  SDA, 
  
  // Temperature sensor
  temp_inout,
  
  // Distance sensor
  Trig1,
  Echo1,
  Trig2,
  Echo2,
  
  // Flame sensor
  Flame,
  
  
  // Route
  record,
  
  // Stimulation
  coil,
  
  // display
  HEX0,
  HEX1,
  HEX2,
  HEX3,
  HEX4,
  HEX5,
  HEX6,
  HEX7,
  LEDR,
  LEDG,
  DOTS,

  // buttons
  KEY,
  SW,
  
//  //////////// SRAM //////////
  SRAM_ADDR,
  SRAM_CE_N,
  SRAM_DQ,
  SRAM_LB_N,
  SRAM_OE_N,
  SRAM_UB_N,
  SRAM_WE_N
);

//==== in/out declaration ==================================
    //-------- input ---------------------------------------
	input clk;

  //IR
  input	IRDA_RXD;
  
  
	//input Tx;
	//RFID
	input MISO;
  
  // Distance
  input Echo1;
  input Echo2;
  
  // Temperature
  inout temp_inout;
  
  // Flame
  input Flame;
	
  input record;  
  
  input [3:0] KEY;
  input [17:0] SW;
    //-------- output -------------------------------------- 
	//output VCC;
	//output GND;
	output RST;
	 //for SPI communication
	output MOSI;
	output SCK;
	output SDA;
  
  // Distance
  output Trig1;
  output Trig2;
	
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	output [6:0] HEX5;
	output [6:0] HEX6;
	output [6:0] HEX7;	
	output [17:0] LEDR; 
  output [7:0] LEDG;
	
  //////////// SRAM //////////
  output [19:0] SRAM_ADDR; 
  output        SRAM_CE_N;
  inout  [15:0] SRAM_DQ;
  output        SRAM_LB_N;
  output        SRAM_OE_N;
  output        SRAM_UB_N;
  output        SRAM_WE_N;
  
  output [4:0] coil;
  output [23:0] DOTS;
  
//==== reg/wire declaration ================================ */
 
  wire [31:0] rfid_data;
  wire [15:0] rfid_info;
  wire [7:0] temp_data;
  wire [19:0] distance1_data;
  wire [19:0] distance2_data;
  
  wire [23:0] DOTS;
  
  //IR
  wire IR_data_ready; 
  wire [31:0] IR_hex_data;
  
  wire reset;

  reg temp_trigger;
  reg next_temp_trigger;
 
  wire route_record;
  wire route_record_left;
  wire route_record_right;
  reg route_start;
  reg next_route_start;
  wire route_done;
  
  wire [7:0] stimulation_state; //DEBUG
  
  reg  [23:0] clks;
  wire [23:0] next_clks;

  assign next_clks = clks + 24'd1;
  
  assign reset = KEY[0];
  assign route_record = ~KEY[3];
  assign route_record_left = ~KEY[1];
  assign route_record_right = ~KEY[2];
 
/* ==== combinational part ================================== */
    
  // clock signal
  clksrc500k clksrc1 (clk, clk1);
  //clksrc16k  clksrc2 (clk, clk16);

	RFID rfid(
    .clk(clk1),
    .reset(reset),

    .RST(RST),
    .MISO(MISO),
    .MOSI(MOSI),
    .SCK(SCK),
    .SDA(SDA),
    
    .rfidData(rfid_data),
    
    .HEX0(HEX0),
    .HEX1(HEX1),
    .HEX2(HEX2),
    .HEX3(HEX3),
    .HEX4(HEX4),
    .HEX5(HEX5),
    .HEX6(HEX6),
    .HEX7(HEX7)
  );

  Route route(
    .clk(clk1),
    .reset(reset),
    .start(route_start),
    .done(route_done),
    .init(SW[17]),
    .record(route_record),
    .record_left(route_record_left),
    .record_right(route_record_right),
    .rfid_data(rfid_data),
    .rfid_info(rfid_info),
    .SW(SW[4:0]),
    .SRAM_ADDR(SRAM_ADDR),
    .SRAM_DQ(SRAM_DQ),
    .SRAM_CE_N(SRAM_CE_N),
    .SRAM_LB_N(SRAM_LB_N),
    .SRAM_OE_N(SRAM_OE_N),
    .SRAM_UB_N(SRAM_UB_N),
    .SRAM_WE_N(SRAM_WE_N),
    .LED(LEDG[6])
  );

  Temperature temperature(
    .clk(clk),
    .trigger(temp_trigger),
    .temp_inout(temp_inout),
    .temp_data_out(temp_data)
  );
  
  Distance distance1(
    .clk(clk),
    .Trig(Trig1),
    .Echo(Echo1),
    .distance(distance1_data)
  );
  
  Distance distance2(
    .clk(clk),
    .Trig(Trig2),
    .Echo(Echo2),
    .distance(distance2_data)
  );

  Stimulation stimulation(
    .clk(clk),
    .reset(reset),
    .coil(coil),
    .rfid_data(rfid_data),
    .rfid_info(rfid_info),
    .temp_data(temp_data),
    .flame(Flame),
    .distance1_data(distance1_data),
    .distance2_data(distance2_data),
    .IR_data(IR_hex_data[23:16]),
    .SW(SW[4:0]),
    .state(stimulation_state),
    .LED(LEDG[0])
  );
  
  Display display(
    .clk(clk),
    .reset(reset),
    .rfid_info(rfid_info),
    .temp_data(temp_data),
    .distance1_data(distance1_data),
    .distance2_data(distance2_data),
    .coil(coil),
    .route_record(route_record),
    .state(stimulation_state),
    .LED(LEDR),
  );
  
  DOT dot(
    .clk(clk1),
    .phase(~coil),
    .DOTS1(DOTS)
  );
  
  IR ir(
    .iCLK(clk), 
    .iRST_n(reset),        
    .iIRDA(IRDA_RXD), 
    .oDATA_READY(IR_data_ready),
    .oDATA(IR_hex_data)//hex_data[19:16]
  );

always@(*) begin
  next_route_start = route_start;
  if (clks[21] == 1'b0 && next_clks[21] == 1'b1)
    next_temp_trigger = 1'b0;
  else
    next_temp_trigger = 1'b1;
end

always@(posedge clk or negedge reset) begin
  if (reset == 1'b0) begin
    clks         <= 24'b0;
    route_start  <= 1'b1;
    temp_trigger <= 1'b1;
  end
  else begin
    clks         <= next_clks;
    route_start  <= next_route_start;
    temp_trigger <= next_temp_trigger;
  end
end

endmodule
