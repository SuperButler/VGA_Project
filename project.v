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
 
reg [3:0] red_reg, green_reg, blue_reg, red_next, green_next, blue_next;

//if ((col >= 11'd && col <= 11'd && row >= 11'd && row <= 11'd) ||
//    (col >= 11'd && col <= 11'd && row >= 11'd && row <= 11'd)) begin
//    red_next    = 4'h; //-Piece 
//    green_next  = 4'h; 
//    blue_next   = 4'h;
//end

// Next state & output logic state  machine 
always@* begin
    //Background
    if (col >= 11'd0 && col <= 11'd640 && row >= 11'd0 && row <= 11'd480) begin
        red_next   <= 4'h0; 
        green_next <= 4'h0;
        blue_next  <= 4'h0;   
    end

    //Peaces
    if ((col >= 11'd120 && col <= 11'd240 && row >= 11'd440 && row <= 11'd480) ||
        (col >= 11'd200 && col <= 11'd240 && row >= 11'd400 && row <= 11'd440)) begin
        red_next    = 4'hF; //L-Piece 
        green_next  = 4'h8; 
        blue_next   = 4'h0;   
    end
    if ((col >= 11'd240 && col <= 11'd360 && row >= 11'd440 && row <= 11'd480) ||
        (col >= 11'd240 && col <= 11'd280 && row >= 11'd400 && row <= 11'd440)) begin
        red_next    = 4'h0; //J-Piece 
        green_next  = 4'h0; 
        blue_next   = 4'hF;
    end    
    if ((col >= 11'd320 && col <= 11'd400 && row >= 11'd400 && row <= 11'd440) ||
        (col >= 11'd360 && col <= 11'd440 && row >= 11'd440 && row <= 11'd480)) begin
        red_next    = 4'hF; //Z-Piece 
        green_next  = 4'h0; 
        blue_next   = 4'h0;
    end
    if ((col >= 11'd400 && col <= 11'd480 && row >= 11'd400 && row <= 11'd440) ||
        (col >= 11'd440 && col <= 11'd480 && row >= 11'd320 && row <= 11'd400)) begin
        red_next    = 4'h0; //J-Piece 
        green_next  = 4'h0; 
        blue_next   = 4'hF;
    end
    if (col >= 11'd120 && col <= 11'd160 && row >= 11'd280 && row <= 11'd440) begin
        red_next    = 4'h0; //I-Piece 
        green_next  = 4'hF; 
        blue_next   = 4'hF;
    end
    if ((col >= 11'd160 && col <= 11'd200 && row >= 11'd360 && row <= 11'd440) ||
        (col >= 11'd200 && col <= 11'd240 && row >= 11'd320 && row <= 11'd400)) begin
        red_next    = 4'hF; //Z-Piece 
        green_next  = 4'h0; 
        blue_next   = 4'h0;
    end
    if ((col >= 11'd240 && col <= 11'd280 && row >= 11'd360 && row <= 11'd400) ||
        (col >= 11'd280 && col <= 11'd320 && row >= 11'd320 && row <= 11'd440)) begin
        red_next    = 4'h8; //T-Piece 
        green_next  = 4'h0; 
        blue_next   = 4'hF;
    end
    if (col >= 11'd320 && col <= 11'd400 && row >= 11'd320 && row <= 11'd400) begin
        red_next    = 4'hF; //O-Piece 
        green_next  = 4'hF; 
        blue_next   = 4'h0;
    end
    if ((col >= 11'd200 && col <= 11'd240 && row >= 11'd240 && row <= 11'd320) ||
        (col >= 11'd240 && col <= 11'd280 && row >= 11'd280 && row <= 11'd360)) begin
        red_next    = 4'h0; //S-Piece 
        green_next  = 4'hF; 
        blue_next   = 4'h0;
    end

    //MovingBlock
    if(col >= 11'd200 && col <= 11'd360 && row >= 11'd0 && row <= 11'd40) begin
        red_next   <= 4'h0; //cyan
        green_next <= 4'hF;
        blue_next  <= 4'hF;
    end    

    //Borders
    if(col >= 11'd0 && col <11'd120) begin
        red_next   <= 4'h2; 
        green_next <= 4'h2;
        blue_next  <= 4'h5;   
    end
    if(col >= 11'd520 && col <11'd640) begin  
        red_next   <= 4'h2; 
        green_next <= 4'h2;
        blue_next  <= 4'h5;  
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
        red_reg   <= red_next;
        green_reg <= green_next;
        blue_reg  <= blue_next;
    end
end
 
// Assign output wires
assign red = red_reg;
assign green = green_reg;
assign blue = blue_reg;
 
endmodule


