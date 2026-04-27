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
    SPEED = 1,  // pixels per update
    HEIGHT = 32, 
    WIDTH = 32,
    NUM_WALLS = 10,
    OFFSEED_0 = 595287,
    OFFSEED_1 = 845687
) (
    input  logic        clk,
    input  logic        reset,
    input  logic        refresh_tick, 
    input  logic [5:0]  switch,
    input  logic [9:0]  player_x,
    input  logic [9:0]  player_y,
    input  logic [9:0]  wall_x_l [NUM_WALLS],
    input  logic [9:0]  wall_x_r [NUM_WALLS],
    input  logic [9:0]  wall_y_t [NUM_WALLS],
    input  logic [9:0]  wall_y_b [NUM_WALLS],
    output logic [9:0]  enemy_x,
    output logic [9:0]  enemy_y
);
logic los_blocked;

logic signed [10:0] ray_x, ray_y;
logic signed [10:0] step_x, step_y;
logic signed [10:0] dir_x, dir_y;
always_comb begin
    los_blocked = 0;

    dir_x = $signed(player_x) - $signed(enemy_x);
    dir_y = $signed(player_y) - $signed(enemy_y);

    step_x = dir_x >>> 4;
    step_y = dir_y >>> 4;

    ray_x = enemy_x;
    ray_y = enemy_y;

    //dont sent out a line. send out dots
    for (int s = 0; s < 16; s++) begin
        ray_x += step_x;
        ray_y += step_y;

        for (int i = 0; i < NUM_WALLS; i++) begin
            if ((ray_x >= wall_x_l[i]) &&
                (ray_x <= wall_x_r[i]) &&
                (ray_y >= wall_y_t[i]) &&
                (ray_y <= wall_y_b[i])) begin
                los_blocked = 1;
            end
        end
    end
end

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

logic [9:0] last_seen_x, last_seen_y;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        last_seen_x <= player_x;
        last_seen_y <= player_y;
    end else if (!los_blocked) begin
        last_seen_x <= player_x;
        last_seen_y <= player_y;
    end
end


logic [9:0] target_x, target_y;

assign target_x = last_seen_x;
assign target_y = last_seen_y;



logic [15:0] lfsr_reg0,lfsr_reg1;
randomNumber #(.OFFSET(OFFSEED_0)) RN0 (.clk(clk),.reset(reset),.seed({switch[3:0],switch[4:1],switch[5:2],switch[3:0]}),.lfsr_number(lfsr_reg0));
randomNumber #(.OFFSET(OFFSEED_1)) RN1 (.clk(clk),.reset(reset),.seed({switch[3:0],switch[4:1],switch[5:2],switch[3:0]}),.lfsr_number(lfsr_reg1));

always_comb begin
    next_x = enemy_x;
    next_y = enemy_y;
    
    if ( (lfsr_reg0[6] && lfsr_reg1[6]) || !los_blocked) begin//1 in 4 to move to the player
        if (target_x > enemy_x) next_x = enemy_x + SPEED;
        else if (target_x < enemy_x) next_x = enemy_x - SPEED;
    
        if (target_y > enemy_y) next_y = enemy_y + SPEED;
        else if (target_y < enemy_y) next_y = enemy_y - SPEED;
    end else begin
        if (lfsr_reg0[8]) next_x = enemy_x + SPEED;
        else next_x = enemy_x - SPEED;
                
        if (lfsr_reg1[9]) next_y = enemy_y + SPEED;
        else next_y = enemy_y - SPEED;
    end
end

always_comb begin
    collision_x = 0;
    temp_next_x = next_x;

    for (int i = 0; i < NUM_WALLS; i++) begin
        if ((next_x + WIDTH >= wall_x_l[i]) &&
            (next_x <= wall_x_r[i]) &&
            (enemy_y + HEIGHT >= wall_y_t[i]) &&
            (enemy_y <= wall_y_b[i])) begin
                collision_x = 1;
                temp_next_x = enemy_x;
        end
    end
end

always_comb begin
    collision_y = 0;
    temp_next_y = next_y;
    for (int i = 0; i < NUM_WALLS; i++) begin
        if ((enemy_x + WIDTH >= wall_x_l[i]) &&
            (enemy_x <= wall_x_r[i]) &&
            (next_y + HEIGHT >= wall_y_t[i]) &&
            (next_y <= wall_y_b[i])) begin
                collision_y = 1;
                temp_next_y = enemy_y;
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