`timescale 1ns / 1ps
 
// File: VGAColourStripes.v
// Author: Michelle Lynch
// Copyright Michelle Lynch 2024
//
// Adapting Author: Seth Butler
// Date: 20/11/2026
 
module ColourStripes #(
    parameter COUNTER_WIDTH = 32, 
    parameter COUNT_FROM = 0,
    parameter COUNT_TO = 32'b1 << 26,
    parameter COUNT_RESET = 32'b1 << 27)
    (input clk, rst,
     input [10:0] row, col, 
     output [3:0] red, green, blue);

reg[4:0] state, state_next;
reg[COUNTER_WIDTH:0] count;
reg[11:0] color;
reg[10:0] x0, x1, y0, y1;
reg [3:0] red_reg, green_reg, blue_reg, red_next, green_next, blue_next;
parameter S00 = 0, S01 = 1, S02 = 2, S03 = 3, S04 = 4, S05 = 5, S06 = 6, S07 = 7, S08 = 8, S09 = 9, S10 = 10, S11 = 11, S12 = 12, S13 = 13, S14 = 14, S15 = 15, S16 = 16, S17 = 17, S18 = 18;
localparam[11:0] BLACK = 12'h000, ORANGE = 12'hF80, BLUE = 12'h00F, RED = 12'hF00, CYAN = 12'h0FF, PURPLE = 12'h80F, YELLOW = 12'hFF0, GREEN  = 12'h0F0, WHITE = 12'hFFF, BORDER = 12'h225;

reg [10:0] srow;
always @* begin
    srow = row;                      
    if (state == S18 && row < 440)   
        srow = row - 40;             
end

//Create pieces
function piece;
    input [10:0] icol, irow, ix0, iy0, ix1, iy1;
    piece = (icol >= ix0 && icol < ix1 && irow >= iy0 && irow < iy1);
endfunction

//Moving Block position
always @* begin
    state_next = state;
    case (state)
        S00:    begin x0 = 200; x1 = 360; y0 =  0;  y1 =  40; if(count == COUNT_TO) begin state_next = S01; end end
        S01:    begin x0 = 240; x1 = 400; y0 =  0;  y1 =  40; if(count == COUNT_TO) begin state_next = S02; end end
        S02:    begin x0 = 280; x1 = 440; y0 =  0;  y1 =  40; if(count == COUNT_TO) begin state_next = S03; end end
        S03:    begin x0 = 280; x1 = 440; y0 = 40;  y1 =  80; if(count == COUNT_TO) begin state_next = S04; end end
        S04:    begin x0 = 360; x1 = 400; y0 =  0;  y1 = 160; if(count == COUNT_TO) begin state_next = S05; end end
        S05:    begin x0 = 400; x1 = 440; y0 =  0;  y1 = 160; if(count == COUNT_TO) begin state_next = S06; end end
        S06:    begin x0 = 400; x1 = 440; y0 = 40;  y1 = 200; if(count == COUNT_TO) begin state_next = S07; end end
        S07:    begin x0 = 440; x1 = 480; y0 = 40;  y1 = 200; if(count == COUNT_TO) begin state_next = S08; end end
        S08:    begin x0 = 440; x1 = 480; y0 = 80;  y1 = 240; if(count == COUNT_TO) begin state_next = S09; end end
        S09:    begin x0 = 440; x1 = 480; y0 = 120; y1 = 280; if(count == COUNT_TO) begin state_next = S10; end end
        S10:    begin x0 = 440; x1 = 480; y0 = 160; y1 = 320; if(count == COUNT_TO) begin state_next = S11; end end
        S11:    begin x0 = 480; x1 = 520; y0 = 160; y1 = 320; if(count == COUNT_TO) begin state_next = S12; end end
        S12:    begin x0 = 480; x1 = 520; y0 = 200; y1 = 360; if(count == COUNT_TO) begin state_next = S13; end end
        S13:    begin x0 = 480; x1 = 520; y0 = 240; y1 = 400; if(count == COUNT_TO) begin state_next = S14; end end
        S14:    begin x0 = 480; x1 = 520; y0 = 280; y1 = 440; if(count == COUNT_TO) begin state_next = S15; end end
        S15:    begin x0 = 480; x1 = 520; y0 = 320; y1 = 480; if(count == COUNT_TO) begin state_next = S16; end end
        S16:    begin x0 = 0; x1 = 0; y0 = 0; y1 = 0; if(count == COUNT_TO) begin state_next = S17; end end
        S17:    begin x0 = 0; x1 = 0; y0 = 0; y1 = 0; if(count == COUNT_TO) begin state_next = S18; end end
        S18:    begin x0 = 0; x1 = 0; y0 = 0; y1 = 0; if(count == COUNT_TO) begin state_next = S00; end end
        default: begin x0 = 440; x1 = 480; y0 = 40; y1 = 200; end
    endcase
end

//Create Static Blocks   
always @* begin
    color = BLACK; // background
    if (piece(col,row, 0,0, 120,480) || piece(col,row, 520,0, 640,480)) color=BORDER;

    if (piece(col,srow, 120,440, 240,480) || piece(col,srow, 200,400, 240,440)) color = ORANGE;
    if (piece(col,srow, 240,440, 360,480) || piece(col,srow, 240,400, 280,440)) color = BLUE;       
    if (piece(col,srow, 320,400, 400,440) || piece(col,srow, 360,440, 440,480)) color = RED;        
    if (piece(col,srow, 400,400, 480,440) || piece(col,srow, 440,320, 480,400)) color = BLUE;       
    if (piece(col,srow, 160,360, 200,440) || piece(col,srow, 200,320, 240,400)) color = RED;        
    if (piece(col,srow, 240,360, 280,400) || piece(col,srow, 280,320, 320,440)) color = PURPLE;     
    if (piece(col,srow, 200,240, 240,320) || piece(col,srow, 240,280, 280,360)) color = GREEN;      
    if (piece(col,srow, 120,280, 160,440)) color = CYAN;       
    if (piece(col,srow, 320,320, 400,400)) color = YELLOW;   

    if (state >= S16 && piece(col,srow, 480,320, 520,480)) color = CYAN;   
    if (state == S16 && piece(col,row, 120,400, 520,440)) color = WHITE;   
    if (state == S17 && piece(col,row, 120,400, 520,440)) color = BLACK;     

    // Moving block
    if (piece(col,row, x0,y0, x1,y1)) color = CYAN;
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