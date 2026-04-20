`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2026 10:22:55 AM
// Design Name: 
// Module Name: enemy
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


module enemy#(
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

logic [10:0] dx, dy;
assign dx = (player_x > enemy_x) ? player_x - enemy_x : enemy_x - player_x;
assign dy = (player_y > enemy_y) ? player_y - enemy_y : enemy_y - player_y;

logic try_x_first;
assign try_x_first = (dx > dy);

logic [9:0] next_x, next_y, temp_next_x,temp_next_y;
logic collision_x, collision_y;

logic [31:0] slow;
always_ff @(posedge clk or posedge reset) begin
    if (reset) slow <= 0;
    else slow <= (slow >= {switch,16'b0}) ? 0 : slow + 1;;
end

logic x_overlap = (player_x < enemy_x + WIDTH-1) && (player_x + WIDTH-1 > enemy_x);
logic y_overlap = (player_y < enemy_y + HEIGHT-1) && (player_y + HEIGHT-1 > enemy_y);

logic move;
assign move = switch[0] && !(x_overlap && y_overlap) &&  (slow == 0);

always_comb begin
    next_x = enemy_x;
    next_y = enemy_y;

    if (try_x_first) begin
        if (player_x > enemy_x) next_x = enemy_x + SPEED;
        else if (player_x < enemy_x) next_x = enemy_x - SPEED;

        if (player_y > enemy_y) next_y = enemy_y + SPEED;
        else if (player_y < enemy_y) next_y = enemy_y - SPEED;
    end else begin
        if (player_y > enemy_y) next_y = enemy_y + SPEED;
        else if (player_y < enemy_y) next_y = enemy_y - SPEED;

        if (player_x > enemy_x) next_x = enemy_x + SPEED;
        else if (player_x < enemy_x) next_x = enemy_x - SPEED;
    end
end

always_comb begin
    collision_x = 0;
    temp_next_y = next_y;

    for (int i = 0; i < NUM_WALLS; i++) begin
        if ((next_x + WIDTH - 1 >= wall_x_l[i]) &&
            (next_x <= wall_x_r[i]) &&
            (enemy_y + HEIGHT - 1 >= wall_y_t[i]) &&
            (enemy_y <= wall_y_b[i])) begin
                collision_x = 1;
                temp_next_y = (next_y - wall_y_t[i]) > 0 ? enemy_y - SPEED: enemy_y + SPEED;
        end
    end
end

always_comb begin
    collision_y = 0;
    temp_next_x = next_x;
    for (int i = 0; i < NUM_WALLS; i++) begin
        if ((enemy_x + WIDTH - 1 >= wall_x_l[i]) &&
            (enemy_x <= wall_x_r[i]) &&
            (next_y + HEIGHT - 1 >= wall_y_t[i]) &&
            (next_y <= wall_y_b[i])) begin
                collision_y = 1;
                temp_next_x = (next_x - wall_x_l[i]) > 0 ? enemy_x - SPEED: enemy_x + SPEED;
        end
    end
end




always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        enemy_x <= 400;
        enemy_y <= 400;
    end else if (move) begin 
        enemy_x <= temp_next_x;
        enemy_y <= temp_next_y;
    end
end





endmodule