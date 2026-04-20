`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2025 08:32:18 PM
// Design Name: 
// Module Name: enemy_chase
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


module enemy_chase #(
    parameter SPEED = 1,  // pixels per update
    parameter HEIGHT = 32,
    parameter WIDTH = 32,
    parameter NUM_WALLS = 5
) (
    input  logic        clk,
    input  logic        reset,
    input  logic        refresh_tick, 
    input  logic [15:0] switch,
    input  logic [9:0]  player_x,
    input  logic [9:0]  player_y,
    input  logic [9:0]  wall_x_l [NUM_WALLS],
    input  logic [9:0]  wall_x_r [NUM_WALLS],
    input  logic [9:0]  wall_y_t [NUM_WALLS],
    input  logic [9:0]  wall_y_b [NUM_WALLS],
    output logic [9:0]  enemy_x,
    output logic [9:0]  enemy_y
);
    logic [9:0] enemy_l, enemy_t;
    logic collision_with_wall;

    logic [31:0] slow;
    
    always_ff @(posedge clk or posedge reset) begin
        if (reset) slow <= 0;
        else slow <= (slow >= {switch,16'b0}) ? 0 : slow + 1;;
    end
  
  
    logic x_overlap = (player_x < enemy_x + WIDTH-1) && (player_x + WIDTH-1 > enemy_x);
    logic y_overlap = (player_y < enemy_y + HEIGHT-1) && (player_y + HEIGHT-1 > enemy_y);
//    logic [11:0] overlap_left   = (enemy_x + WIDTH) - player_x;           // enemy hits player's left side
//    logic [11:0] overlap_right  = (player_x + WIDTH) - enemy_x;          // enemy hits player's right
//    logic [11:0] overlap_bottom = (enemy_y + HEIGHT) - player_y;           // hits bottom
//    logic [11:0] overlap_top    = (player_y + HEIGHT) - enemy_y;          // hits top
    
    logic move;
    assign move = !(x_overlap && y_overlap);
    
    logic [9:0] next_x, next_y;
    wire [9:0] next_x_r = next_x + WIDTH - 1;
    wire [9:0] next_y_b = next_y + HEIGHT - 1;

    always_comb begin
        next_x = enemy_x;
        next_y = enemy_y;
    
        if (move) begin
            if (player_x > enemy_x)
                next_x = enemy_x + SPEED;
            else if (player_x < enemy_x)
                next_x = enemy_x - SPEED;
    
            if (player_y > enemy_y)
                next_y = enemy_y + SPEED;
            else if (player_y < enemy_y)
                next_y = enemy_y - SPEED;
        end
    end

    always_comb begin
        collision_with_wall = 0;
    
        for (int i = 0; i < NUM_WALLS; i++) begin
            if ((next_x_r >= wall_x_l[i]) &&
                (next_x <= wall_x_r[i]) &&
                (next_y_b >= wall_y_t[i]) &&
                (next_y <= wall_y_b[i])) begin
                    collision_with_wall = 1;
            end
        end
    end
    
//    logic [9:0] next_temp_x, next_temp_y;
//    wire [9:0] next_temp_x_r = next_temp_x + WIDTH - 1;
//    wire [9:0] next_temp_y_b = next_temp_y + HEIGHT - 1;

//    always_comb begin
//        next_temp_x = next_x;
//        next_temp_y = next_y;
    
//        if (collision_with_wall) begin
//            if (player_x > enemy_x)
//                next_temp_x = enemy_x + SPEED;
//            else if (player_x < enemy_x)
//                next_temp_x = enemy_x - SPEED;
    
//            if (player_y > enemy_y)
//                next_temp_y = enemy_y + SPEED;
//            else if (player_y < enemy_y)
//                next_temp_y = enemy_y - SPEED;
//        end
//    end
    
    

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            enemy_x <= 400;
            enemy_y <= 400;
        end else if((slow == 0)&& !collision_with_wall)begin
            enemy_x <= next_x;
            enemy_y <= next_y;
            end else begin 
            enemy_x <= enemy_x;
            enemy_y <= enemy_y;
            end
    end
endmodule
