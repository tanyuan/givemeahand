module Route(
    clk,
    reset,
    start,
    done,
    rfid_data,
    rfid_info,
    SW,
    init,
    record,
    record_left,
    record_right,
    SRAM_ADDR,
    SRAM_DQ,
    SRAM_CE_N,
    SRAM_LB_N,
    SRAM_OE_N,
    SRAM_UB_N,
    SRAM_WE_N,
    LED
);

// Mapping the RFID card number to SRAM address
// ============================================
// Pick the first 5 hex (20 bits) and map to the address
//
// The original RFID card number: 32'hC4243351
// The same card stored in SRAM:  SRAM_ADDR = 20'hC4243
// Data stored in the address:    SRAM_DQ[0] = 1 exist, 0 not exist
//                                SRAM_DQ[2:1] = 01 left,  10 right, 00 none
//                                SRAM_DQ[4:3] = 01 top,   10 down,  00 none
//                                SRAM_DQ[6:5] = 01 drop,  00 none
//                                other spatial information?


  input clk;
  input reset;
  input start;
  input [31:0] rfid_data;
  input [4:0] SW;
  input init;
  input record;
  input record_left;
  input record_right;
  output done;
  output[15:0] rfid_info;

  output LED;

  // SRAM ////////////////////////////
  output [19:0] SRAM_ADDR;  
  inout  [15:0] SRAM_DQ;
  output        SRAM_CE_N;
  output        SRAM_LB_N;
  output        SRAM_OE_N;
  output        SRAM_UB_N;
  output        SRAM_WE_N;

  reg    [19:0] SRAM_ADDR;  
  reg           SRAM_CE_N;
  reg           SRAM_LB_N;
  reg           SRAM_OE_N;
  reg           SRAM_UB_N;
  reg           SRAM_WE_N;

  reg    [19:0] next_SRAM_ADDR;  
  reg           next_SRAM_CE_N;
  reg           next_SRAM_LB_N;
  reg           next_SRAM_OE_N;
  reg           next_SRAM_UB_N;
  reg           next_SRAM_WE_N;
  
  reg    [15:0] SRAM_DQ_REG;
  reg    [15:0] next_SRAM_DQ_REG;

  reg LED;
  reg next_LED;

  reg done;
  reg next_done;
  
  reg init_done;
  reg next_init_done;
  
  reg [15:0] rfid_info;
  reg [15:0] next_rfid_info;

  wire [15:0] SRAM_DQ_OUT;

  reg [2:0] state;
  reg [2:0] next_state;

  reg [4:0] init_state;
  reg [4:0] next_init_state;
  reg [4:0] read_state;
  reg [4:0] next_read_state;
  reg [4:0] write_state;
  reg [4:0] next_write_state;
  
  reg [1:0] record_state;
  reg [1:0] next_record_state;
  
  // State
  parameter INIT  = 3'd0;
  parameter READ  = 3'd1;
  parameter WRITE = 3'd2;
  
  parameter id1 = 32'hC4243351;
  parameter id2 = 32'h0E8A3E4E;
  
  assign SRAM_DQ = (state == INIT || state == WRITE) ? SRAM_DQ_OUT : 16'bz;
  assign SRAM_DQ_OUT = SRAM_DQ_REG;
  
  always@(*) begin
    next_state = state;
    next_init_state  = init_state;
    next_read_state  = read_state;
    next_write_state = write_state;
    next_record_state = record_state;
    next_init_done   = init_done;
    next_done        = done;
    next_rfid_info   = rfid_info;
    next_SRAM_DQ_REG = SRAM_DQ_REG;
    next_SRAM_ADDR   = SRAM_ADDR;
    next_SRAM_CE_N   = SRAM_CE_N;
    next_SRAM_LB_N   = SRAM_LB_N;
    next_SRAM_OE_N   = SRAM_OE_N;
    next_SRAM_UB_N   = SRAM_UB_N;
    next_SRAM_WE_N   = SRAM_WE_N;
    next_LED         = LED;
    
    case (state)
    // Reset SRAM to all zeros //////////////////////////////
    INIT: begin
      case(init_state)
        5'd0: begin
          next_SRAM_ADDR = 20'b0;
          next_SRAM_CE_N = 1'b0;
          next_SRAM_OE_N = 1'b1;
          next_SRAM_WE_N = 1'b0;
          next_init_state = 5'd1;
        end
        5'd1: begin        
          next_SRAM_DQ_REG = 16'b0; // set all to zeros
          if (SRAM_ADDR == 20'b1111_1111_1111_1111_1111) begin // till the end of SRAM
            next_init_state = 5'd2;
          end
          else begin
            
            next_SRAM_ADDR = SRAM_ADDR + 20'b1;
            next_init_state = 5'd1;
          end
        end
        5'd2: begin          
          next_init_done = 1'b1;
          next_init_state = 5'd2;
          next_state = READ;
        end
      endcase
    end
    // Read from SRAM //////////////////////////////
    READ: begin
      case(read_state)
        5'd0: begin
          next_done = 1'b0;
          if (init == 1'b1 && init_done == 1'b0)
            next_state = INIT;
          if (record == 1'b1) begin
            next_state = WRITE;
            next_write_state = 5'd0;
          end
          else if (record_left == 1'b1) begin
            next_state = WRITE;
            next_write_state = 5'd0;
            next_record_state = 2'd1;            
          end
          else if (record_right == 1'b1) begin
            next_state = WRITE;
            next_write_state = 5'd0;
            next_record_state = 2'd2;
          end
          else begin
            if (start == 1'b1)
              next_read_state = 5'd1;
            else
              next_read_state = 5'd0;
          end
        end
        5'd1: begin          
          next_SRAM_CE_N = 1'b0;
          next_SRAM_OE_N = 1'b0;
          next_SRAM_WE_N = 1'b1;          
          next_read_state = 5'd2;
        end
        5'd2: begin
          // Find the mapping address
          next_SRAM_ADDR = rfid_data[31:12];
          next_read_state = 5'd3;
        end
        5'd3: begin
          // Check the last bit of SRAM_DQ see if the card exists
          if (SRAM_DQ[0] == 1'b1) begin
            next_LED = 1'b1; // DEBUG
            next_rfid_info = SRAM_DQ;            
            next_read_state = 5'd0;
          end
          else begin
            next_LED = 1'b0; // DEBUG
            next_rfid_info = 16'b0;
          end
          next_read_state = 5'd0;
          next_done = 1'b1;
        end
      endcase
    end
    // Write to SRAM /////////////////////////////////
    WRITE: begin    
      case (write_state)
        5'd0: begin
          next_done = 1'b0;
          if (start == 1'b1)
            next_write_state = 5'd1;
          else
            next_write_state = 5'd0;
        end
        5'd1: begin         
          next_SRAM_CE_N = 1'b0;
          next_SRAM_OE_N = 1'b1;
          next_SRAM_WE_N = 1'b0;
          next_write_state = 5'd2;
        end
        5'd2: begin          
          // Find the mapping address
          next_SRAM_ADDR = rfid_data[31:12];
          if (record_state == 2'd1) // Record shortcut for left gesture
            next_write_state = 5'd4;
          else if (record_state == 2'd2) // Record shortcut for right gesture
            next_write_state = 5'd5;
          else // General record
            next_write_state = 5'd3;
        end
        5'd3: begin
          if (SW[0] == 1'b1)
            next_SRAM_DQ_REG = 16'b0_00_00_00_00_00_00_01_1;
          else if (SW[1] == 1'b1)
            next_SRAM_DQ_REG = 16'b0_00_00_00_00_00_00_10_1;
          else if (SW[2] == 1'b1)
            next_SRAM_DQ_REG = 16'b0_00_00_00_00_00_01_00_1;
          else if (SW[3] == 1'b1)
            next_SRAM_DQ_REG = 16'b0_00_00_00_00_00_10_00_1;
          else if (SW[4] == 1'b1)
            next_SRAM_DQ_REG = 16'b0_00_00_00_00_01_00_00_1;
          else
            next_SRAM_DQ_REG = 16'b0_00_00_00_00_00_00_00_0;
          next_write_state = 5'd6;
        end
        5'd4: begin
          next_SRAM_DQ_REG = 16'b0_00_00_00_00_00_00_01_1;
          next_record_state = 2'd0;
          next_write_state = 5'd6;
        end
        5'd5: begin
          next_SRAM_DQ_REG = 16'b0_00_00_00_00_00_00_10_1;
          next_record_state = 2'd0;
          next_write_state = 5'd6;
        end
        5'd6: begin
          next_done = 1'b1;
          next_write_state = 5'd0;
          next_state = READ;
        end
      endcase
    end
    
// write with two specific card id1 and id2
//    WRITE: begin    
//      case (write_state)
//        5'd0: begin
//          next_done = 1'b0;
//          if (start == 1'b1)
//            next_write_state = 5'd1;
//          else
//            next_write_state = 5'd0;
//        end
//        5'd1: begin         
//          next_SRAM_CE_N = 1'b0;
//          next_SRAM_OE_N = 1'b1;
//          next_SRAM_WE_N = 1'b0;
//          next_write_state = 5'd2;
//        end
//        5'd2: begin
//          next_SRAM_ADDR = id1[31:12]; // Go to the mapping address
//          next_write_state = 5'd3;
//        end
//        5'd3: begin
//          next_SRAM_DQ_REG = 16'b0_00_00_00_00_00_00_01_1;
//          next_write_state = 5'd4;
//        end
//        5'd4: begin
//          next_SRAM_ADDR = id2[31:12]; // Go to the mapping address
//          next_write_state = 5'd5;
//        end
//        5'd5: begin
//          next_SRAM_DQ_REG = 16'b0_00_00_00_00_00_01_00_1;
//          next_write_state = 5'd6;
//        end
//        5'd6: begin
//          next_done = 1'b1;
//          next_write_state = 5'd0;
//        end
//      endcase
//    end
    
    endcase
  end

  always@(posedge clk or negedge reset) begin
    if (reset == 1'b0) begin
      state       <= READ;
      init_state  <= 5'd0;
      read_state  <= 5'd0;
      write_state <= 5'd0;
      record_state <= 2'd0;
      init_done   <= 1'b0;
      done        <= 1'b0;
      rfid_info   <= 16'b0;
      SRAM_DQ_REG <= 16'b0;
      SRAM_ADDR   <= 20'b0; 
      SRAM_CE_N   <= 1'b1;
      SRAM_OE_N   <= 1'b1;
      SRAM_WE_N   <= 1'b1;
      SRAM_LB_N   <= 1'b0;
      SRAM_UB_N   <= 1'b0;
      LED         <= 1'b0;
    end
    else begin
      state       <= next_state;
      init_state  <= next_init_state;
      read_state  <= next_read_state;
      write_state <= next_write_state;
      record_state <= next_record_state;
      init_done   <= next_init_done;
      done        <= next_done;
      rfid_info   <= next_rfid_info;
      SRAM_DQ_REG <= next_SRAM_DQ_REG;
      SRAM_ADDR   <= next_SRAM_ADDR;
      SRAM_CE_N   <= next_SRAM_CE_N;
      SRAM_LB_N   <= next_SRAM_LB_N;
      SRAM_OE_N   <= next_SRAM_OE_N;
      SRAM_UB_N   <= next_SRAM_UB_N;
      SRAM_WE_N   <= next_SRAM_WE_N;
      LED         <= next_LED;
    end
  end

endmodule
