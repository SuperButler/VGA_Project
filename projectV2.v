`timescale 1ns / 1ps
 
// File: VGAColourStripes.v
// Author: Michelle Lynch
// Copyright Michelle Lynch 2024
//
// Adapting Author: 
// Date:
 
module ColourStripes #(
    parameter COUNTER_WIDTH = 32, 
    parameter COUNT_FROM = 0,
    parameter COUNT_TO = 32'b1 << 26,
    parameter COUNT_RESET = 32'b1 << 27)
    (input clk, rst,
     input [10:0] row, col, 
     output [3:0] red, green, blue);
 
parameter S00 = 0, S01 = 1, S02 = 2, S03 = 3, S04 = 4, S05 = 5, S06 = 6, S07 = 7, S08 = 8, S09 = 9, S10 = 10;
reg[2:0] state, state_next;
reg[COUNTER_WIDTH:0] count;
reg[11:0] color;

reg [3:0] red_reg, green_reg, blue_reg, red_next, green_next, blue_next;

// Next state & output logic state  machine 
always@* begin
    state_next = state;
    case(state)
        S00: begin
            //Background
            if (col >= 11'd0 && col < 11'd640 && row >= 11'd0 && row < 11'd480) begin 
                color <= 12'h000;
            end
            //Borders
            if((col >= 11'd0 && col < 11'd120) || (col >= 11'd520 && col < 11'd640)) begin  
                color <= 12'h225;
            end
            //Peaces
            if ((col >= 11'd120 && col < 11'd240 && row >= 11'd440 && row < 11'd480) ||
                (col >= 11'd200 && col < 11'd240 && row >= 11'd400 && row < 11'd440)) begin 
                color <= 12'hF80; //L-Piece  
            end
            if ((col >= 11'd240 && col < 11'd360 && row >= 11'd440 && row < 11'd480) ||
                (col >= 11'd240 && col < 11'd280 && row >= 11'd400 && row < 11'd440)) begin
                color <= 12'h00F; //J-Piece 
            end    
            if ((col >= 11'd320 && col < 11'd400 && row >= 11'd400 && row < 11'd440) ||
                (col >= 11'd360 && col < 11'd440 && row >= 11'd440 && row < 11'd480)) begin
                color <= 12'hF00; //Z-Piece
            end
            if ((col >= 11'd400 && col < 11'd480 && row >= 11'd400 && row < 11'd440) ||
                (col >= 11'd440 && col < 11'd480 && row >= 11'd320 && row < 11'd400)) begin
                color <= 12'h00F; //J-Piece
            end
            if (col >= 11'd120 && col < 11'd160 && row >= 11'd280 && row < 11'd440) begin
                color <= 12'h0FF; //I-Piece
            end
            if ((col >= 11'd160 && col < 11'd200 && row >= 11'd360 && row < 11'd440) ||
                (col >= 11'd200 && col < 11'd240 && row >= 11'd320 && row < 11'd400)) begin
                color <= 12'hF00; //Z-Piece
            end
            if ((col >= 11'd240 && col < 11'd280 && row >= 11'd360 && row < 11'd400) ||
                (col >= 11'd280 && col < 11'd320 && row >= 11'd320 && row < 11'd440)) begin
                color <= 12'h80F; //T-Piece 
            end
            if (col >= 11'd320 && col < 11'd400 && row >= 11'd320 && row < 11'd400) begin
                color <= 12'hFF0; //O-Piece 
            end
            if ((col >= 11'd200 && col < 11'd240 && row >= 11'd240 && row < 11'd320) ||
                (col >= 11'd240 && col < 11'd280 && row >= 11'd280 && row < 11'd360)) begin
                color <= 12'h0F0; //S-Piece 
            end
        
            //MovingBlock
            if(col >= 11'd200 && col < 11'd360 && row >= 11'd0 && row < 11'd40) begin
                color <= 12'h0FF; //I-Piece (moving)
            end 
            if(count == COUNT_TO) begin
                state_next = S01;
            end
        end 
        S01: begin
            //Background
            if (col >= 11'd0 && col < 11'd640 && row >= 11'd0 && row < 11'd480) begin 
                color <= 12'h000;
            end
            //Borders
            if((col >= 11'd0 && col < 11'd120) || (col >= 11'd520 && col < 11'd640)) begin  
                color <= 12'h225;
            end
            //Peaces
            if ((col >= 11'd120 && col < 11'd240 && row >= 11'd440 && row < 11'd480) ||
                (col >= 11'd200 && col < 11'd240 && row >= 11'd400 && row < 11'd440)) begin 
                color <= 12'hF80; //L-Piece  
            end
            if ((col >= 11'd240 && col < 11'd360 && row >= 11'd440 && row < 11'd480) ||
                (col >= 11'd240 && col < 11'd280 && row >= 11'd400 && row < 11'd440)) begin
                color <= 12'h00F; //J-Piece 
            end    
            if ((col >= 11'd320 && col < 11'd400 && row >= 11'd400 && row < 11'd440) ||
                (col >= 11'd360 && col < 11'd440 && row >= 11'd440 && row < 11'd480)) begin
                color <= 12'hF00; //Z-Piece
            end
            if ((col >= 11'd400 && col < 11'd480 && row >= 11'd400 && row < 11'd440) ||
                (col >= 11'd440 && col < 11'd480 && row >= 11'd320 && row < 11'd400)) begin
                color <= 12'h00F; //J-Piece
            end
            if (col >= 11'd120 && col < 11'd160 && row >= 11'd280 && row < 11'd440) begin
                color <= 12'h0FF; //I-Piece
            end
            if ((col >= 11'd160 && col < 11'd200 && row >= 11'd360 && row < 11'd440) ||
                (col >= 11'd200 && col < 11'd240 && row >= 11'd320 && row < 11'd400)) begin
                color <= 12'hF00; //Z-Piece
            end
            if ((col >= 11'd240 && col < 11'd280 && row >= 11'd360 && row < 11'd400) ||
                (col >= 11'd280 && col < 11'd320 && row >= 11'd320 && row < 11'd440)) begin
                color <= 12'h80F; //T-Piece 
            end
            if (col >= 11'd320 && col < 11'd400 && row >= 11'd320 && row < 11'd400) begin
                color <= 12'hFF0; //O-Piece 
            end
            if ((col >= 11'd200 && col < 11'd240 && row >= 11'd240 && row < 11'd320) ||
                (col >= 11'd240 && col < 11'd280 && row >= 11'd280 && row < 11'd360)) begin
                color <= 12'h0F0; //S-Piece 
            end
        
            //MovingBlock
            if(col >= 11'd240 && col < 11'd400 && row >= 11'd0 && row < 11'd40) begin
                color <= 12'h0FF; //I-Piece (moving)
            end 
            if(count == COUNT_TO) begin
                state_next = S02;
            end 
        end
        S02: begin
            //Background
            if (col >= 11'd0 && col < 11'd640 && row >= 11'd0 && row < 11'd480) begin 
                color <= 12'h000;
            end
            //Borders
            if((col >= 11'd0 && col < 11'd120) || (col >= 11'd520 && col < 11'd640)) begin  
                color <= 12'h225;
            end
            //Peaces
            if ((col >= 11'd120 && col < 11'd240 && row >= 11'd440 && row < 11'd480) ||
                (col >= 11'd200 && col < 11'd240 && row >= 11'd400 && row < 11'd440)) begin 
                color <= 12'hF80; //L-Piece  
            end
            if ((col >= 11'd240 && col < 11'd360 && row >= 11'd440 && row < 11'd480) ||
                (col >= 11'd240 && col < 11'd280 && row >= 11'd400 && row < 11'd440)) begin
                color <= 12'h00F; //J-Piece 
            end    
            if ((col >= 11'd320 && col < 11'd400 && row >= 11'd400 && row < 11'd440) ||
                (col >= 11'd360 && col < 11'd440 && row >= 11'd440 && row < 11'd480)) begin
                color <= 12'hF00; //Z-Piece
            end
            if ((col >= 11'd400 && col < 11'd480 && row >= 11'd400 && row < 11'd440) ||
                (col >= 11'd440 && col < 11'd480 && row >= 11'd320 && row < 11'd400)) begin
                color <= 12'h00F; //J-Piece
            end
            if (col >= 11'd120 && col < 11'd160 && row >= 11'd280 && row < 11'd440) begin
                color <= 12'h0FF; //I-Piece
            end
            if ((col >= 11'd160 && col < 11'd200 && row >= 11'd360 && row < 11'd440) ||
                (col >= 11'd200 && col < 11'd240 && row >= 11'd320 && row < 11'd400)) begin
                color <= 12'hF00; //Z-Piece
            end
            if ((col >= 11'd240 && col < 11'd280 && row >= 11'd360 && row < 11'd400) ||
                (col >= 11'd280 && col < 11'd320 && row >= 11'd320 && row < 11'd440)) begin
                color <= 12'h80F; //T-Piece 
            end
            if (col >= 11'd320 && col < 11'd400 && row >= 11'd320 && row < 11'd400) begin
                color <= 12'hFF0; //O-Piece 
            end
            if ((col >= 11'd200 && col < 11'd240 && row >= 11'd240 && row < 11'd320) ||
                (col >= 11'd240 && col < 11'd280 && row >= 11'd280 && row < 11'd360)) begin
                color <= 12'h0F0; //S-Piece 
            end
        
            //MovingBlock
            if(col >= 11'd280 && col < 11'd440 && row >= 11'd0 && row < 11'd40) begin
                color <= 12'h0FF; //I-Piece (moving)
            end 
            if(count == COUNT_TO) begin
                state_next = S03;
            end 
        end
        S03: begin
            //Background
            if (col >= 11'd0 && col < 11'd640 && row >= 11'd0 && row < 11'd480) begin 
                color <= 12'h000;
            end
            //Borders
            if((col >= 11'd0 && col < 11'd120) || (col >= 11'd520 && col < 11'd640)) begin  
                color <= 12'h225;
            end
            //Peaces
            if ((col >= 11'd120 && col < 11'd240 && row >= 11'd440 && row < 11'd480) ||
                (col >= 11'd200 && col < 11'd240 && row >= 11'd400 && row < 11'd440)) begin 
                color <= 12'hF80; //L-Piece  
            end
            if ((col >= 11'd240 && col < 11'd360 && row >= 11'd440 && row < 11'd480) ||
                (col >= 11'd240 && col < 11'd280 && row >= 11'd400 && row < 11'd440)) begin
                color <= 12'h00F; //J-Piece 
            end    
            if ((col >= 11'd320 && col < 11'd400 && row >= 11'd400 && row < 11'd440) ||
                (col >= 11'd360 && col < 11'd440 && row >= 11'd440 && row < 11'd480)) begin
                color <= 12'hF00; //Z-Piece
            end
            if ((col >= 11'd400 && col < 11'd480 && row >= 11'd400 && row < 11'd440) ||
                (col >= 11'd440 && col < 11'd480 && row >= 11'd320 && row < 11'd400)) begin
                color <= 12'h00F; //J-Piece
            end
            if (col >= 11'd120 && col < 11'd160 && row >= 11'd280 && row < 11'd440) begin
                color <= 12'h0FF; //I-Piece
            end
            if ((col >= 11'd160 && col < 11'd200 && row >= 11'd360 && row < 11'd440) ||
                (col >= 11'd200 && col < 11'd240 && row >= 11'd320 && row < 11'd400)) begin
                color <= 12'hF00; //Z-Piece
            end
            if ((col >= 11'd240 && col < 11'd280 && row >= 11'd360 && row < 11'd400) ||
                (col >= 11'd280 && col < 11'd320 && row >= 11'd320 && row < 11'd440)) begin
                color <= 12'h80F; //T-Piece 
            end
            if (col >= 11'd320 && col < 11'd400 && row >= 11'd320 && row < 11'd400) begin
                color <= 12'hFF0; //O-Piece 
            end
            if ((col >= 11'd200 && col < 11'd240 && row >= 11'd240 && row < 11'd320) ||
                (col >= 11'd240 && col < 11'd280 && row >= 11'd280 && row < 11'd360)) begin
                color <= 12'h0F0; //S-Piece 
            end
        
            //MovingBlock
            if(col >= 11'd280 && col < 11'd440 && row >= 11'd40 && row < 11'd80) begin
                color <= 12'h0FF; //I-Piece (moving)
            end 
            if(count == COUNT_TO) begin
                state_next = S04;
            end 
        end
        S04: begin
            //Background
            if (col >= 11'd0 && col < 11'd640 && row >= 11'd0 && row < 11'd480) begin 
                color <= 12'h000;
            end
            //Borders
            if((col >= 11'd0 && col < 11'd120) || (col >= 11'd520 && col < 11'd640)) begin  
                color <= 12'h225;
            end
            //Peaces
            if ((col >= 11'd120 && col < 11'd240 && row >= 11'd440 && row < 11'd480) ||
                (col >= 11'd200 && col < 11'd240 && row >= 11'd400 && row < 11'd440)) begin 
                color <= 12'hF80; //L-Piece  
            end
            if ((col >= 11'd240 && col < 11'd360 && row >= 11'd440 && row < 11'd480) ||
                (col >= 11'd240 && col < 11'd280 && row >= 11'd400 && row < 11'd440)) begin
                color <= 12'h00F; //J-Piece 
            end    
            if ((col >= 11'd320 && col < 11'd400 && row >= 11'd400 && row < 11'd440) ||
                (col >= 11'd360 && col < 11'd440 && row >= 11'd440 && row < 11'd480)) begin
                color <= 12'hF00; //Z-Piece
            end
            if ((col >= 11'd400 && col < 11'd480 && row >= 11'd400 && row < 11'd440) ||
                (col >= 11'd440 && col < 11'd480 && row >= 11'd320 && row < 11'd400)) begin
                color <= 12'h00F; //J-Piece
            end
            if (col >= 11'd120 && col < 11'd160 && row >= 11'd280 && row < 11'd440) begin
                color <= 12'h0FF; //I-Piece
            end
            if ((col >= 11'd160 && col < 11'd200 && row >= 11'd360 && row < 11'd440) ||
                (col >= 11'd200 && col < 11'd240 && row >= 11'd320 && row < 11'd400)) begin
                color <= 12'hF00; //Z-Piece
            end
            if ((col >= 11'd240 && col < 11'd280 && row >= 11'd360 && row < 11'd400) ||
                (col >= 11'd280 && col < 11'd320 && row >= 11'd320 && row < 11'd440)) begin
                color <= 12'h80F; //T-Piece 
            end
            if (col >= 11'd320 && col < 11'd400 && row >= 11'd320 && row < 11'd400) begin
                color <= 12'hFF0; //O-Piece 
            end
            if ((col >= 11'd200 && col < 11'd240 && row >= 11'd240 && row < 11'd320) ||
                (col >= 11'd240 && col < 11'd280 && row >= 11'd280 && row < 11'd360)) begin
                color <= 12'h0F0; //S-Piece 
            end
        
            //MovingBlock
            if(col >= 11'd360 && col < 11'd400 && row >= 11'd0 && row < 11'd160) begin
                color <= 12'h0FF; //I-Piece (moving)
            end 
            if(count == COUNT_TO) begin
                state_next = S05;
            end 
        end
        S05: begin
            //Background
            if (col >= 11'd0 && col < 11'd640 && row >= 11'd0 && row < 11'd480) begin 
                color <= 12'h000;
            end
            //Borders
            if((col >= 11'd0 && col < 11'd120) || (col >= 11'd520 && col < 11'd640)) begin  
                color <= 12'h225;
            end
            //Peaces
            if ((col >= 11'd120 && col < 11'd240 && row >= 11'd440 && row < 11'd480) ||
                (col >= 11'd200 && col < 11'd240 && row >= 11'd400 && row < 11'd440)) begin 
                color <= 12'hF80; //L-Piece  
            end
            if ((col >= 11'd240 && col < 11'd360 && row >= 11'd440 && row < 11'd480) ||
                (col >= 11'd240 && col < 11'd280 && row >= 11'd400 && row < 11'd440)) begin
                color <= 12'h00F; //J-Piece 
            end    
            if ((col >= 11'd320 && col < 11'd400 && row >= 11'd400 && row < 11'd440) ||
                (col >= 11'd360 && col < 11'd440 && row >= 11'd440 && row < 11'd480)) begin
                color <= 12'hF00; //Z-Piece
            end
            if ((col >= 11'd400 && col < 11'd480 && row >= 11'd400 && row < 11'd440) ||
                (col >= 11'd440 && col < 11'd480 && row >= 11'd320 && row < 11'd400)) begin
                color <= 12'h00F; //J-Piece
            end
            if (col >= 11'd120 && col < 11'd160 && row >= 11'd280 && row < 11'd440) begin
                color <= 12'h0FF; //I-Piece
            end
            if ((col >= 11'd160 && col < 11'd200 && row >= 11'd360 && row < 11'd440) ||
                (col >= 11'd200 && col < 11'd240 && row >= 11'd320 && row < 11'd400)) begin
                color <= 12'hF00; //Z-Piece
            end
            if ((col >= 11'd240 && col < 11'd280 && row >= 11'd360 && row < 11'd400) ||
                (col >= 11'd280 && col < 11'd320 && row >= 11'd320 && row < 11'd440)) begin
                color <= 12'h80F; //T-Piece 
            end
            if (col >= 11'd320 && col < 11'd400 && row >= 11'd320 && row < 11'd400) begin
                color <= 12'hFF0; //O-Piece 
            end
            if ((col >= 11'd200 && col < 11'd240 && row >= 11'd240 && row < 11'd320) ||
                (col >= 11'd240 && col < 11'd280 && row >= 11'd280 && row < 11'd360)) begin
                color <= 12'h0F0; //S-Piece 
            end
        
            //MovingBlock
            if(col >= 11'd360 && col < 11'd400 && row >= 11'd40 && row < 11'd200) begin
                color <= 12'h0FF; //I-Piece (moving)
            end 
            if(count == COUNT_TO) begin
                state_next = S06;
            end 
        end
        S06: begin
            //Background
            if (col >= 11'd0 && col < 11'd640 && row >= 11'd0 && row < 11'd480) begin 
                color <= 12'h000;
            end
            //Borders
            if((col >= 11'd0 && col < 11'd120) || (col >= 11'd520 && col < 11'd640)) begin  
                color <= 12'h225;
            end
            //Peaces
            if ((col >= 11'd120 && col < 11'd240 && row >= 11'd440 && row < 11'd480) ||
                (col >= 11'd200 && col < 11'd240 && row >= 11'd400 && row < 11'd440)) begin 
                color <= 12'hF80; //L-Piece  
            end
            if ((col >= 11'd240 && col < 11'd360 && row >= 11'd440 && row < 11'd480) ||
                (col >= 11'd240 && col < 11'd280 && row >= 11'd400 && row < 11'd440)) begin
                color <= 12'h00F; //J-Piece 
            end    
            if ((col >= 11'd320 && col < 11'd400 && row >= 11'd400 && row < 11'd440) ||
                (col >= 11'd360 && col < 11'd440 && row >= 11'd440 && row < 11'd480)) begin
                color <= 12'hF00; //Z-Piece
            end
            if ((col >= 11'd400 && col < 11'd480 && row >= 11'd400 && row < 11'd440) ||
                (col >= 11'd440 && col < 11'd480 && row >= 11'd320 && row < 11'd400)) begin
                color <= 12'h00F; //J-Piece
            end
            if (col >= 11'd120 && col < 11'd160 && row >= 11'd280 && row < 11'd440) begin
                color <= 12'h0FF; //I-Piece
            end
            if ((col >= 11'd160 && col < 11'd200 && row >= 11'd360 && row < 11'd440) ||
                (col >= 11'd200 && col < 11'd240 && row >= 11'd320 && row < 11'd400)) begin
                color <= 12'hF00; //Z-Piece
            end
            if ((col >= 11'd240 && col < 11'd280 && row >= 11'd360 && row < 11'd400) ||
                (col >= 11'd280 && col < 11'd320 && row >= 11'd320 && row < 11'd440)) begin
                color <= 12'h80F; //T-Piece 
            end
            if (col >= 11'd320 && col < 11'd400 && row >= 11'd320 && row < 11'd400) begin
                color <= 12'hFF0; //O-Piece 
            end
            if ((col >= 11'd200 && col < 11'd240 && row >= 11'd240 && row < 11'd320) ||
                (col >= 11'd240 && col < 11'd280 && row >= 11'd280 && row < 11'd360)) begin
                color <= 12'h0F0; //S-Piece 
            end
        
            //MovingBlock
            if(col >= 11'd400 && col < 11'd440 && row >= 11'd40 && row < 11'd200) begin
                color <= 12'h0FF; //I-Piece (moving)
            end 
            if(count == COUNT_TO) begin
                state_next = S07;
            end 
        end
        S07: begin
            //Background
            if (col >= 11'd0 && col < 11'd640 && row >= 11'd0 && row < 11'd480) begin 
                color <= 12'h000;
            end
            //Borders
            if((col >= 11'd0 && col < 11'd120) || (col >= 11'd520 && col < 11'd640)) begin  
                color <= 12'h225;
            end
            //Peaces
            if ((col >= 11'd120 && col < 11'd240 && row >= 11'd440 && row < 11'd480) ||
                (col >= 11'd200 && col < 11'd240 && row >= 11'd400 && row < 11'd440)) begin 
                color <= 12'hF80; //L-Piece  
            end
            if ((col >= 11'd240 && col < 11'd360 && row >= 11'd440 && row < 11'd480) ||
                (col >= 11'd240 && col < 11'd280 && row >= 11'd400 && row < 11'd440)) begin
                color <= 12'h00F; //J-Piece 
            end    
            if ((col >= 11'd320 && col < 11'd400 && row >= 11'd400 && row < 11'd440) ||
                (col >= 11'd360 && col < 11'd440 && row >= 11'd440 && row < 11'd480)) begin
                color <= 12'hF00; //Z-Piece
            end
            if ((col >= 11'd400 && col < 11'd480 && row >= 11'd400 && row < 11'd440) ||
                (col >= 11'd440 && col < 11'd480 && row >= 11'd320 && row < 11'd400)) begin
                color <= 12'h00F; //J-Piece
            end
            if (col >= 11'd120 && col < 11'd160 && row >= 11'd280 && row < 11'd440) begin
                color <= 12'h0FF; //I-Piece
            end
            if ((col >= 11'd160 && col < 11'd200 && row >= 11'd360 && row < 11'd440) ||
                (col >= 11'd200 && col < 11'd240 && row >= 11'd320 && row < 11'd400)) begin
                color <= 12'hF00; //Z-Piece
            end
            if ((col >= 11'd240 && col < 11'd280 && row >= 11'd360 && row < 11'd400) ||
                (col >= 11'd280 && col < 11'd320 && row >= 11'd320 && row < 11'd440)) begin
                color <= 12'h80F; //T-Piece 
            end
            if (col >= 11'd320 && col < 11'd400 && row >= 11'd320 && row < 11'd400) begin
                color <= 12'hFF0; //O-Piece 
            end
            if ((col >= 11'd200 && col < 11'd240 && row >= 11'd240 && row < 11'd320) ||
                (col >= 11'd240 && col < 11'd280 && row >= 11'd280 && row < 11'd360)) begin
                color <= 12'h0F0; //S-Piece 
            end
            
            //MovingBlock
            if(col >= 11'd440 && col < 11'd480 && row >= 11'd40 && row < 11'd200) begin
                color <= 12'h0FF; //I-Piece (moving)
            end 
            if(count == COUNT_TO) begin
                state_next = S00;
            end 
        end
    endcase              
end

// Register state
always@(posedge clk, posedge rst) begin
    if(rst == 1'b1)
        state <= S00;
    else
        state <= state_next;
end

// Counter
always@(posedge clk, posedge rst) begin
    if(rst == 1'b1)
        count <= COUNT_FROM;
    else
    begin
        if(count == COUNT_TO)
            count <= 0;
        else
            count <= count + 1;
    end
end
 
// Register RGB outputs    
always@(posedge clk, posedge rst) begin
    if(rst == 1'b1) begin
        red_reg   <= 4'hF;
        green_reg <= 4'hF;
        blue_reg  <= 4'hF;
    end
    else begin
        red_reg   <= color[11:8];
        green_reg <= color[7:4];
        blue_reg  <= color[3:0];
    end
end
 
// Assign output wires
assign red = red_reg;
assign green = green_reg;
assign blue = blue_reg;
 
endmodule