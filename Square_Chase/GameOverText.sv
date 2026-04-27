`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2026 03:39:24 PM
// Design Name: 
// Module Name: Font
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module GameOverText #(
    parameter SCREEN_W = 640,
    parameter SCREEN_H = 480,
    parameter SCALE    = 4,
    parameter EXPONENT = 5
)(
    input  logic [9:0] pixel_x,
    input  logic [9:0] pixel_y,
    input  logic [3:0] score_10[EXPONENT],
    output logic text_on
);

// ---------------- Font params ----------------
localparam CHAR_W = 8;
localparam CHAR_H = 8;

// "GAME OVER"
localparam TITLE_CHARS = 9;

// Score (max 65535 : 5 digits)
localparam SCORE_CHARS = 5;

// Layout
localparam TITLE_W = TITLE_CHARS * CHAR_W * SCALE;
localparam SCORE_W = SCORE_CHARS * CHAR_W * SCALE;

localparam TITLE_X = (SCREEN_W - TITLE_W) / 2;
localparam TITLE_Y = (SCREEN_H / 2) - (CHAR_H * SCALE);

localparam SCORE_X = (SCREEN_W - SCORE_W) / 2;
localparam SCORE_Y = TITLE_Y + (CHAR_H * SCALE) + 10; // below title

// ---------------- Internal ----------------
logic signed [11:0] rel_x_title, rel_y_title;
logic signed [11:0] rel_x_score, rel_y_score;

logic [9:0] scaled_x, scaled_y;
logic [3:0] char_col;
logic [2:0] char_row;
logic [2:0] char_bit;

logic [7:0] current_char;
logic [7:0] font_bits;

logic title_on, score_on;

// ---------------- SCALE ----------------
assign scaled_x = (pixel_x - TITLE_X) / SCALE;
assign scaled_y = (pixel_y - TITLE_Y) / SCALE;

// ---------------- TITLE ----------------
assign rel_x_title = pixel_x - TITLE_X;
assign rel_y_title = pixel_y - TITLE_Y;

logic in_title;
assign in_title =
    (rel_x_title >= 0) && (rel_x_title < TITLE_W) &&
    (rel_y_title >= 0) && (rel_y_title < CHAR_H*SCALE);

logic [3:0] title_col;
assign title_col = scaled_x / CHAR_W;

always_comb begin
    case (title_col)
        0: current_char = "G";
        1: current_char = "A";
        2: current_char = "M";
        3: current_char = "E";
        4: current_char = " ";
        5: current_char = "O";
        6: current_char = "V";
        7: current_char = "E";
        8: current_char = "R";
        default: current_char = " ";
    endcase
end

assign char_row = scaled_y % CHAR_H;
assign char_bit = scaled_x % CHAR_W;

Font font_inst (
    .char(current_char),
    .row(char_row),
    .bits(font_bits)
);

assign title_on = in_title ? font_bits[7 - char_bit] : 1'b0;

// ---------------- SCORE ----------------

// Score region
assign rel_x_score = pixel_x - SCORE_X;
assign rel_y_score = pixel_y - SCORE_Y;

logic in_score;
assign in_score =
    (rel_x_score >= 0) && (rel_x_score < SCORE_W) &&
    (rel_y_score >= 0) && (rel_y_score < CHAR_H*SCALE);

// Scale for score
logic [9:0] score_scaled_x, score_scaled_y;
assign score_scaled_x = rel_x_score / SCALE;
assign score_scaled_y = rel_y_score / SCALE;

logic [3:0] score_col;
assign score_col = score_scaled_x / CHAR_W;

logic [7:0] score_char;

always_comb begin
    case (score_col)
        0: score_char = "0" + score_10[4];
        1: score_char = "0" + score_10[3];
        2: score_char = "0" + score_10[2];
        3: score_char = "0" + score_10[1];
        4: score_char = "0" + score_10[0];
        default: score_char = " ";
    endcase
end

logic [2:0] score_row, score_bit;
assign score_row = score_scaled_y % CHAR_H;
assign score_bit = score_scaled_x % CHAR_W;

logic [7:0] score_bits;

Font font_score (
    .char(score_char),
    .row(score_row),
    .bits(score_bits)
);

assign score_on = in_score ? score_bits[7 - score_bit] : 1'b0;

// Output
assign text_on = title_on | score_on;

endmodule