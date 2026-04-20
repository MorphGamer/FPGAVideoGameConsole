`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2026 11:24:23 PM
// Design Name: 
// Module Name: walls
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


module walls #(
    parameter HEIGHT = 32,
    parameter WIDTH = 32,
    parameter MIN_X = 10,
    parameter MIN_Y = 20,
    parameter MAX_X = 630,
    parameter MAX_Y = 470,
    parameter NUM_WALLS = 5,
    parameter OFFSEED_1 = 6585,
    parameter OFFSEED_2 = 2865,
    parameter OFFSEED_3 = 96585
) (
    input   logic        clk,
    input   logic        reset,
    input   logic [15:0] seed,
    output  logic [9:0]  wall_x_l [NUM_WALLS],
    output  logic [9:0]  wall_x_r [NUM_WALLS],
    output  logic [9:0]  wall_y_t [NUM_WALLS],
    output  logic [9:0]  wall_y_b [NUM_WALLS]
);
    logic [15:0] lfsr_reg1,lfsr_reg2,lfsr_reg3;
    
    int count = 0;
    
    // 1. Generate the LFSR feedback (taps for 16-bit: 16, 14, 13, 11)
    wire feedback1 = lfsr_reg1[15] ^ lfsr_reg1[13] ^ lfsr_reg1[12] ^ lfsr_reg1[10];
    wire feedback2 = lfsr_reg2[15] ^ lfsr_reg2[14] ^ lfsr_reg2[12] ^ lfsr_reg2[9];
    wire feedback3 = lfsr_reg3[15] ^ lfsr_reg3[12] ^ lfsr_reg3[11] ^ lfsr_reg3[10];

    always_ff @(posedge clk) begin
        if (reset) begin
            lfsr_reg1 <= seed + OFFSEED_1; // Non-zero seed
            lfsr_reg2 <= seed + OFFSEED_2;
            lfsr_reg3 <= seed + OFFSEED_3;
            count <= 0;
            for (int i = 1; i <NUM_WALLS; i++) begin
                wall_x_l[i] <= 0;
                wall_x_r[i] <= 0;
                wall_y_t[i] <= 0;
                wall_y_b[i] <= 0;
            end 
        end else if (count < NUM_WALLS) begin
            lfsr_reg1 <= {lfsr_reg1[14:0], feedback1};
            lfsr_reg2 <= {lfsr_reg2[14:0], feedback2};
            lfsr_reg3 <= {lfsr_reg3[14:0], feedback3};
            
            wall_x_l[count] <= (lfsr_reg1 % (MAX_X - MIN_X + 1)) + MIN_X;
            wall_x_r[count] <= feedback3 ? 20 : (lfsr_reg3 % (MAX_X - MIN_X + 1)) + (lfsr_reg1 % (MAX_X - MIN_X + 1)) + MIN_X;
            wall_y_t[count] <= (lfsr_reg2 % (MAX_Y - MIN_Y + 1)) + MIN_Y;
            wall_y_b[count] <= !feedback3 ? 20 :(lfsr_reg3 % (MAX_Y - MIN_Y + 1)) + (lfsr_reg2 % (MAX_Y - MIN_Y + 1)) + MIN_Y;
            
            
            count <= count + 1;
        end
    end
endmodule

