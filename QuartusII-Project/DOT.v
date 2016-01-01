module DOT(
  clk,
  //clks,
  //next_clks,
  phase,
  DOTS1
  //phase_time
);
    
    
  parameter Freq_Animax_1 = 20;   //23=1hz , 20=8hz, 18=64hz 
  parameter Freq_Animax_2 = 19;   //Freq_2 = Freq_1 - 2

  parameter Freq_Display_1 = 12;  //23=1hz , 20=8hz, 18=64hz 
  parameter Freq_Display_2 = 10;  // Freq_2 = Freq_1 - 2
    
// I-O
  input clk;
  input [4:0]phase;//8
  //input [23:0]next_clks;
  output [23:0] DOTS1;

    
// Wire
  reg [23:0] DOTS1;
  reg [3:0]  AniCounter;
  reg [3:0]  next_AniCounter;
  reg  [26:0] clks;
  wire [26:0] next_clks;

  assign next_clks = clks + 27'd1;
    
    
    
 //亮燈   //right matrix
  always@(*) begin
       
    //Left==========================================================================
    if(phase ==5'b00001) begin  //Left~~
        
        case(clks[Freq_Animax_1:Freq_Animax_2])
            2'd0:    begin //DOTS1=pic0 
                case(clks[Freq_Display_1:Freq_Display_2])
                    3'd0: DOTS1=24'b011110010010010010011010; //DOTS1=24'b011110110010010011011010;
                    3'd1: DOTS1=24'b110011010010010010011011; //DOTS1=24'b110111010010010010011011;
                    3'd2: DOTS1=24'b110010011110011010010010; //DOTS1=24'b110010011110011010010011;
                    3'd3: DOTS1=24'b010010110111011011010010; //DOTS1=24'b010010110111011011010010;
                    3'd4: DOTS1=24'b010010010110011010010110; //DOTS1=24'b010010110110011011010110;
                    3'd5: DOTS1=24'b110010010010010010110011; //DOTS1=24'b110010010110011010110011;
                    3'd6: DOTS1=24'b010110010010010110011010; //DOTS1=24'b110110010010010110011011;
                    3'd7: DOTS1=24'b010110110010110011011010; //DOTS1=24'b010110110010110011011010;
                endcase            
                //if(clks[Freq_Animax_1]==1'b1 && next_clks[Freq_Animax_1]==1'b0) AniCounter=4'd1; 
            end
            
            
            2'd1:    begin //DOTS1=pic1;  
                case(clks[Freq_Display_1:Freq_Display_2])
                    3'd0: DOTS1=24'b111110010010010010011011;
                    3'd1: DOTS1=24'b110011010110011010010011;
                    3'd2: DOTS1=24'b010010111110011011010010;
                    3'd3: DOTS1=24'b010110110011010011011010;
                    3'd4: DOTS1=24'b010110110010010011011110;
                    3'd5: DOTS1=24'b010010110110011011110010;
                    3'd6: DOTS1=24'b110010010110011110010011;
                    3'd7: DOTS1=24'b110110010010110010011011;
                endcase                             
                //if(clks[Freq_Animax_1]==1'b1 && next_clks[Freq_Animax_1]==1'b0) AniCounter=4'd2; 
            end
            2'd2:    begin //DOTS1=pic2;  
                case(clks[Freq_Display_1:Freq_Display_2])
                    3'd0: DOTS1=24'b111010010110011010010011;
                    3'd1: DOTS1=24'b010011110110011011010010;
                    3'd2: DOTS1=24'b010110111010010011011010;
                    3'd3: DOTS1=24'b110110010011010010011011;
                    3'd4: DOTS1=24'b110110010010010010011111;
                    3'd5: DOTS1=24'b010110110010010011111010;
                    3'd6: DOTS1=24'b010010110110011111010010;
                    3'd7: DOTS1=24'b110010010110111010010011;
                endcase                             
                //if(clks[Freq_Animax_1]==1'b1 && next_clks[Freq_Animax_1]==1'b0) AniCounter=4'd3; 
            end
            2'd3:    begin //DOTS1=pic3;  
                case(clks[Freq_Display_1:Freq_Display_2])
                    3'd0: DOTS1=24'b011010110110011011010010;
                    3'd1: DOTS1=24'b010111110010010011011010;
                    3'd2: DOTS1=24'b110110011010010010011011;
                    3'd3: DOTS1=24'b110010010111011010010011;
                    3'd4: DOTS1=24'b110010010110011010010111;
                    3'd5: DOTS1=24'b110110010010010010111011;
                    3'd6: DOTS1=24'b010110110010010111011010;
                    3'd7: DOTS1=24'b010010110110111011010010;
                endcase                             
                //if(clks[Freq_Animax_1]==1'b1 && next_clks[Freq_Animax_1]==1'b0) AniCounter=4'd4; 
            end
            default: //AniCounter=4'd0;
                begin //DOTS1=pic0 
                    case(clks[Freq_Display_1:Freq_Display_2])
                        3'd0: DOTS1=24'b111110110110011011011011;
                        3'd1: DOTS1=24'b110111110110011011011011;
                        3'd2: DOTS1=24'b110110111110011011011011;
                        3'd3: DOTS1=24'b110110110011011011011010;
                        3'd4: DOTS1=24'b110110110010011011011110;
                        3'd5: DOTS1=24'b110110110110011011111011;
                        3'd6: DOTS1=24'b110110110110011111011011;
                        3'd7: DOTS1=24'b110110110110111011011011;
                    endcase     
                    //if(clks[Freq_Animax_1]==1'b1 && next_clks[Freq_Animax_1]==1'b0) AniCounter=4'd1; 
                end
        endcase
     //AniCounter=(clks[Freq_Animax_1]==1'b1 && next_clks[Freq_Animax_1]==1'b0) ?AniCounter+4'd1:AniCounter;                 
    end
    
    //Right==========================================================================
    else if(phase ==5'b00010) begin  //Right~~
        
        case(clks[Freq_Animax_1:Freq_Animax_2])
            2'd0:    begin //DOTS1=pic0 
                case(clks[Freq_Display_1:Freq_Display_2])
                    3'd0: DOTS1=24'b011110110010010011011010;
                    3'd1: DOTS1=24'b010011110110011011010010;
                    3'd2: DOTS1=24'b110010011110011010010011;
                    3'd3: DOTS1=24'b110110010011010010011011;
                    3'd4: DOTS1=24'b110110010010010010011111;
                    3'd5: DOTS1=24'b110010010110011010110011;
                    3'd6: DOTS1=24'b010010110110011111010010;
                    3'd7: DOTS1=24'b010110110010110011011010;
                endcase     
                //if(clks[Freq_Animax_1]==1'b1 && next_clks[Freq_Animax_1]==1'b0) AniCounter=4'd1; 
            end
            
            
            2'd1:    begin //DOTS1=pic1;  
                case(clks[Freq_Display_1:Freq_Display_2])
                    3'd0: DOTS1=24'b011010110110011011010010;
                    3'd1: DOTS1=24'b110011010110011010010011;
                    3'd2: DOTS1=24'b110110011010010010011011;
                    3'd3: DOTS1=24'b010110110011010011011010;
                    3'd4: DOTS1=24'b010110110010010011011110;
                    3'd5: DOTS1=24'b110110010010010010111011;
                    3'd6: DOTS1=24'b110010010110011110010011;
                    3'd7: DOTS1=24'b010010110110111011010010;
                endcase                             
                //if(clks[Freq_Animax_1]==1'b1 && next_clks[Freq_Animax_1]==1'b0) AniCounter=4'd2; 
            end
            2'd2:    begin //DOTS1=pic2;  
                case(clks[Freq_Display_1:Freq_Display_2])
                    3'd0: DOTS1=24'b111010010110011010010011;
                    3'd1: DOTS1=24'b110111010010010010011011;
                    3'd2: DOTS1=24'b010110111010010011011010;
                    3'd3: DOTS1=24'b010010110111011011010010;
                    3'd4: DOTS1=24'b010010110110011011010110;
                    3'd5: DOTS1=24'b010110110010010011111010;
                    3'd6: DOTS1=24'b110110010010010110011011;
                    3'd7: DOTS1=24'b110010010110111010010011;
                endcase                             
                //if(clks[Freq_Animax_1]==1'b1 && next_clks[Freq_Animax_1]==1'b0) AniCounter=4'd3; 
            end
            2'd3:    begin //DOTS1=pic3;  
                case(clks[Freq_Display_1:Freq_Display_2])
                    3'd0: DOTS1=24'b111110010010010010011011;
                    3'd1: DOTS1=24'b010111110010010011011010;
                    3'd2: DOTS1=24'b010010111110011011010010;
                    3'd3: DOTS1=24'b110010010111011010010011;
                    3'd4: DOTS1=24'b110010010110011010010111;
                    3'd5: DOTS1=24'b010010110110011011110010;
                    3'd6: DOTS1=24'b010110110010010111011010;
                    3'd7: DOTS1=24'b110110010010110010011011;
                endcase                             
                //if(clks[Freq_Animax_1]==1'b1 && next_clks[Freq_Animax_1]==1'b0) AniCounter=4'd4; 
            end
            default: //AniCounter=4'd0;
                begin //DOTS1=pic0 
                    case(clks[Freq_Display_1:Freq_Display_2])
                        3'd0: DOTS1=24'b111110110110011011011011;
                        3'd1: DOTS1=24'b110111110110011011011011;
                        3'd2: DOTS1=24'b110110111110011011011011;
                        3'd3: DOTS1=24'b110110110011011011011010;
                        3'd4: DOTS1=24'b110110110010011011011110;
                        3'd5: DOTS1=24'b110110110110011011111011;
                        3'd6: DOTS1=24'b110110110110011111011011;
                        3'd7: DOTS1=24'b110110110110111011011011;
                    endcase     
                    //if(clks[Freq_Animax_1]==1'b1 && next_clks[Freq_Animax_1]==1'b0) AniCounter=4'd1; 
                end
        endcase
     //AniCounter=(clks[Freq_Animax_1]==1'b1 && next_clks[Freq_Animax_1]==1'b0) ?AniCounter+4'd1:AniCounter;                 
    end
    
    //Up==========================================================================
    else if(phase ==5'b00100) begin  //Up~~
        
        case(clks[Freq_Animax_1:Freq_Animax_2])
            2'd0:    begin //DOTS1=pic0 
                case(clks[Freq_Display_1:Freq_Display_2])
                    3'd0: DOTS1=24'b011110110010010011011010;
                    3'd1: DOTS1=24'b110111010010011011010010;
                    3'd2: DOTS1=24'b110010011110011010010011;
                    3'd3: DOTS1=24'b010010110111010010011011;
                    3'd4: DOTS1=24'b010110110010010011011110;
                    3'd5: DOTS1=24'b110110010010011011110010;
                    3'd6: DOTS1=24'b110010010110011110010011;
                    3'd7: DOTS1=24'b010010110110110010011011;
                endcase     
                //if(clks[Freq_Animax_1]==1'b1 && next_clks[Freq_Animax_1]==1'b0) AniCounter=4'd1; 
            end
            
            
            2'd1:    begin //DOTS1=pic1;  
                case(clks[Freq_Display_1:Freq_Display_2])
                    3'd0: DOTS1=24'b111110010010011011010010;
                    3'd1: DOTS1=24'b110011010110011010010011;
                    3'd2: DOTS1=24'b010010111110010010011011;
                    3'd3: DOTS1=24'b010110110011010011011010;
                    3'd4: DOTS1=24'b110110010010011011010110;
                    3'd5: DOTS1=24'b110010010110011010110011;
                    3'd6: DOTS1=24'b010010110110010110011011;
                    3'd7: DOTS1=24'b010110110010110011011010;
                endcase                             
                //if(clks[Freq_Animax_1]==1'b1 && next_clks[Freq_Animax_1]==1'b0) AniCounter=4'd2; 
            end
            2'd2:    begin //DOTS1=pic2;  
                case(clks[Freq_Display_1:Freq_Display_2])
                    3'd0: DOTS1=24'b111010010110011010010011;
                    3'd1: DOTS1=24'b010011110110010010011011;
                    3'd2: DOTS1=24'b010110111010010011011010;
                    3'd3: DOTS1=24'b110110010011011011010010;
                    3'd4: DOTS1=24'b110010010110011010010111;
                    3'd5: DOTS1=24'b010010110110010010111011;
                    3'd6: DOTS1=24'b010110110010010111011010;
                    3'd7: DOTS1=24'b110110010010111011010010;
                endcase                             
                //if(clks[Freq_Animax_1]==1'b1 && next_clks[Freq_Animax_1]==1'b0) AniCounter=4'd3; 
            end
            2'd3:    begin //DOTS1=pic3;  
                case(clks[Freq_Display_1:Freq_Display_2])
                    3'd0: DOTS1=24'b011010110110010010011011;
                    3'd1: DOTS1=24'b010111110010010011011010;
                    3'd2: DOTS1=24'b110110011010011011010010;
                    3'd3: DOTS1=24'b110010010111011010010011;
                    3'd4: DOTS1=24'b010010110110010010011111;
                    3'd5: DOTS1=24'b010110110010010011111010;
                    3'd6: DOTS1=24'b110110010010011111010010;
                    3'd7: DOTS1=24'b110010010110111010010011;
                endcase                             
                //if(clks[Freq_Animax_1]==1'b1 && next_clks[Freq_Animax_1]==1'b0) AniCounter=4'd4; 
            end
            default: //AniCounter=4'd0;
                begin //DOTS1=pic0 
                    case(clks[Freq_Display_1:Freq_Display_2])
                        3'd0: DOTS1=24'b111110110110011011011011;
                        3'd1: DOTS1=24'b110111110110011011011011;
                        3'd2: DOTS1=24'b110110111110011011011011;
                        3'd3: DOTS1=24'b110110110011011011011010;
                        3'd4: DOTS1=24'b110110110010011011011110;
                        3'd5: DOTS1=24'b110110110110011011111011;
                        3'd6: DOTS1=24'b110110110110011111011011;
                        3'd7: DOTS1=24'b110110110110111011011011;
                    endcase     
                    //if(clks[Freq_Animax_1]==1'b1 && next_clks[Freq_Animax_1]==1'b0) AniCounter=4'd1; 
                end
        endcase
     //AniCounter=(clks[Freq_Animax_1]==1'b1 && next_clks[Freq_Animax_1]==1'b0) ?AniCounter+4'd1:AniCounter;                 
    end
    
    //Down==========================================================================
    else if(phase ==5'b01000) begin  //Down~~
        
        case(clks[Freq_Animax_1:Freq_Animax_2])
            2'd0:    begin //DOTS1=pic0 
                case(clks[Freq_Display_1:Freq_Display_2])
                    3'd0: DOTS1=24'b011010110110010010011011;
                    3'd1: DOTS1=24'b110011010110011010010011;
                    3'd2: DOTS1=24'b110110011010011011010010;
                    3'd3: DOTS1=24'b010110110011010011011010;
                    3'd4: DOTS1=24'b010010110110010010011111;
                    3'd5: DOTS1=24'b110010010110011010110011;
                    3'd6: DOTS1=24'b110110010010011111010010;
                    3'd7: DOTS1=24'b010110110010110011011010;
                endcase     
                //if(clks[Freq_Animax_1]==1'b1 && next_clks[Freq_Animax_1]==1'b0) AniCounter=4'd1; 
            end
            
            
            2'd1:    begin //DOTS1=pic1;  
                case(clks[Freq_Display_1:Freq_Display_2])
                    3'd0: DOTS1=24'b011110110010010011011010;
                    3'd1: DOTS1=24'b010011110110010010011011;
                    3'd2: DOTS1=24'b110010011110011010010011;
                    3'd3: DOTS1=24'b110110010011011011010010;
                    3'd4: DOTS1=24'b010110110010010011011110;
                    3'd5: DOTS1=24'b010010110110010010111011;
                    3'd6: DOTS1=24'b110010010110011110010011;
                    3'd7: DOTS1=24'b110110010010111011010010;
                endcase                             
                //if(clks[Freq_Animax_1]==1'b1 && next_clks[Freq_Animax_1]==1'b0) AniCounter=4'd2; 
            end
            2'd2:    begin //DOTS1=pic2;  
                case(clks[Freq_Display_1:Freq_Display_2])
                    3'd0: DOTS1=24'b111110010010011011010010;
                    3'd1: DOTS1=24'b010111110010010011011010;
                    3'd2: DOTS1=24'b010010111110010010011011;
                    3'd3: DOTS1=24'b110010010111011010010011;
                    3'd4: DOTS1=24'b110110010010011011010110;
                    3'd5: DOTS1=24'b010110110010010011111010;
                    3'd6: DOTS1=24'b010010110110010110011011;
                    3'd7: DOTS1=24'b110010010110111010010011;
                endcase                             
                //if(clks[Freq_Animax_1]==1'b1 && next_clks[Freq_Animax_1]==1'b0) AniCounter=4'd3; 
            end
            2'd3:    begin //DOTS1=pic3;  
                case(clks[Freq_Display_1:Freq_Display_2])
                    3'd0: DOTS1=24'b111010010110011010010011;
                    3'd1: DOTS1=24'b110111010010011011010010;
                    3'd2: DOTS1=24'b010110111010010011011010;
                    3'd3: DOTS1=24'b010010110111010010011011;
                    3'd4: DOTS1=24'b110010010110011010010111;
                    3'd5: DOTS1=24'b110110010010011011110010;
                    3'd6: DOTS1=24'b010110110010010111011010;
                    3'd7: DOTS1=24'b010010110110110010011011;
                endcase                             
                //if(clks[Freq_Animax_1]==1'b1 && next_clks[Freq_Animax_1]==1'b0) AniCounter=4'd4; 
            end
            default: //AniCounter=4'd0;
                begin //DOTS1=pic0 
                    case(clks[Freq_Display_1:Freq_Display_2])
                        3'd0: DOTS1=24'b111110110110011011011011;
                        3'd1: DOTS1=24'b110111110110011011011011;
                        3'd2: DOTS1=24'b110110111110011011011011;
                        3'd3: DOTS1=24'b110110110011011011011010;
                        3'd4: DOTS1=24'b110110110010011011011110;
                        3'd5: DOTS1=24'b110110110110011011111011;
                        3'd6: DOTS1=24'b110110110110011111011011;
                        3'd7: DOTS1=24'b110110110110111011011011;
                    endcase     
                    //if(clks[Freq_Animax_1]==1'b1 && next_clks[Freq_Animax_1]==1'b0) AniCounter=4'd1; 
                end
        endcase
     //AniCounter=(clks[Freq_Animax_1]==1'b1 && next_clks[Freq_Animax_1]==1'b0) ?AniCounter+4'd1:AniCounter;                 
    end

    //nothing========================================================================
    else begin //do nothing            
         case(clks[Freq_Display_1:Freq_Display_2])  
            3'b000: DOTS1=24'b111110110110011011011011;
            3'b001: DOTS1=24'b110111110110011011011011;
            3'b010: DOTS1=24'b110110111110011011011011;
            3'b011: DOTS1=24'b110110110111011011011011;
            3'b100: DOTS1=24'b110110110110011011011111;
            3'b101: DOTS1=24'b110110110110011011111011;
            3'b110: DOTS1=24'b110110110110011111011011;
            3'b111: DOTS1=24'b110110110110111011011011;
        endcase
        //AniCounter=4'd0;
    end
  end

  always @(posedge clk)begin
    clks       <= next_clks;
  end
  
endmodule
    
    