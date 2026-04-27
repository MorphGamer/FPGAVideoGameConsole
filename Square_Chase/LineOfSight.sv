`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2026 11:19:08 AM
// Design Name: 
// Module Name: LineOfSight
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


//module LineOfSight#(
//    parameter HEIGHT = 32,
//    parameter WIDTH = 32,
//    parameter NUM_WALLS = 5
//) (
//    input  logic        clk,
//    input  logic        reset,
//    input  logic        refresh_tick, 
//    input  logic [15:0] switch,
//    input  logic [9:0]  player_x,
//    input  logic [9:0]  player_y,
//    input  logic [9:0]  wall_x_l [NUM_WALLS],
//    input  logic [9:0]  wall_x_r [NUM_WALLS],
//    input  logic [9:0]  wall_y_t [NUM_WALLS],
//    input  logic [9:0]  wall_y_b [NUM_WALLS],
//    output logic [9:0]  enemy_x,
//    output logic [9:0]  enemy_y
//);
//module line_of_sight #(
//    parameter NUM_OBS = 8,
//    parameter STEPS   = 32
//)(
//    input  logic clk,
//    input  logic start,

//    input  logic signed [15:0] enemy_x,
//    input  logic signed [15:0] enemy_y,

//    input  logic signed [15:0] player_x,
//    input  logic signed [15:0] player_y,

//    input  aabb_t obstacles [NUM_OBS],

//    output logic visible,
//    output logic done
//);

//    logic signed [15:0] dx, dy;
//    logic signed [15:0] step_x, step_y;

//    logic signed [15:0] cur_x, cur_y;
//    logic [7:0] step_count;

//    logic blocked;

//    // Compute direction
//    always_ff @(posedge clk) begin
//        if (start) begin
//            dx <= player_x - enemy_x;
//            dy <= player_y - enemy_y;

//            step_x <= (player_x - enemy_x) / STEPS;
//            step_y <= (player_y - enemy_y) / STEPS;

//            cur_x <= enemy_x;
//            cur_y <= enemy_y;

//            step_count <= 0;
//            blocked <= 0;
//            done <= 0;
//        end else if (!done) begin
//            cur_x <= cur_x + step_x;
//            cur_y <= cur_y + step_y;

//            step_count <= step_count + 1;

//            // Check collision with obstacles
//            for (int i = 0; i < NUM_OBS; i++) begin
//                if (cur_x >= obstacles[i].min_x &&
//                    cur_x <= obstacles[i].max_x &&
//                    cur_y >= obstacles[i].min_y &&
//                    cur_y <= obstacles[i].max_y) begin
//                    blocked <= 1;
//                end
//            end

//            if (step_count == STEPS) begin
//                visible <= !blocked;
//                done <= 1;
//            end
//        end
//    end
    
//endmodule
