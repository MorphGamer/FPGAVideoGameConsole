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


module Font (
    input  logic [7:0] char,
    input  logic [2:0] row,
    output logic [7:0] bits
);

//8x8 pixel characters.
//based off
//https://www.istockphoto.com/vector/pixel-retro-arcade-game-style-font-gm1333357575-415887069
always_comb begin
    case (char)

        "G": case (row)
            0: bits = 8'b00111100;
            1: bits = 8'b01100110;
            2: bits = 8'b01100000;
            3: bits = 8'b01101110;
            4: bits = 8'b01100110;
            5: bits = 8'b01100110;
            6: bits = 8'b00111100;
            default: bits = 0;
        endcase

        "A": case (row)
            0: bits = 8'b00111100;
            1: bits = 8'b01100110;
            2: bits = 8'b01100110;
            3: bits = 8'b01100110;
            4: bits = 8'b01111110;
            5: bits = 8'b01100110;
            6: bits = 8'b01100110;
            default: bits = 0;
        endcase

        "M": case (row)
            0: bits = 8'b01100011;
            1: bits = 8'b01110111;
            2: bits = 8'b01111111;
            3: bits = 8'b01101011;
            4: bits = 8'b01100011;
            5: bits = 8'b01100011;
            6: bits = 8'b01100011;
            default: bits = 0;
        endcase

        "E": case (row)
            0: bits = 8'b01111110;
            1: bits = 8'b01100000;
            2: bits = 8'b01100000;
            3: bits = 8'b01111100;
            4: bits = 8'b01100000;
            5: bits = 8'b01100000;
            6: bits = 8'b01111110;
            default: bits = 0;
        endcase

        "O": case (row)
            0: bits = 8'b00111100;
            1: bits = 8'b01100110;
            2: bits = 8'b01100110;
            3: bits = 8'b01100110;
            4: bits = 8'b01100110;
            5: bits = 8'b01100110;
            6: bits = 8'b00111100;
            default: bits = 0;
        endcase

        "V": case (row)
            0: bits = 8'b01100110;
            1: bits = 8'b01100110;
            2: bits = 8'b01100110;
            3: bits = 8'b01100110;
            4: bits = 8'b01100110;
            5: bits = 8'b00111100;
            6: bits = 8'b00011000;
            default: bits = 0;
        endcase

        "R": case (row)
            0: bits = 8'b01111100;
            1: bits = 8'b01100110;
            2: bits = 8'b01100110;
            3: bits = 8'b01100110;
            4: bits = 8'b01111100;
            5: bits = 8'b01100110;
            6: bits = 8'b01100110;
            default: bits = 0;
        endcase
        
                "0": case (row)
            0: bits = 8'b00111100;
            1: bits = 8'b01100110;
            2: bits = 8'b01101110;
            3: bits = 8'b01110110;
            4: bits = 8'b01100110;
            5: bits = 8'b01100110;
            6: bits = 8'b00111100;
            default: bits = 0;
        endcase

        "1": case (row)
            0: bits = 8'b00011000;
            1: bits = 8'b00111000;
            2: bits = 8'b00011000;
            3: bits = 8'b00011000;
            4: bits = 8'b00011000;
            5: bits = 8'b00011000;
            6: bits = 8'b00111100;
            default: bits = 0;
        endcase

        "2": case (row)
            0: bits = 8'b00111100;
            1: bits = 8'b01100110;
            2: bits = 8'b00000110;
            3: bits = 8'b00001100;
            4: bits = 8'b00110000;
            5: bits = 8'b01100000;
            6: bits = 8'b01111110;
            default: bits = 0;
        endcase

        "3": case (row)
            0: bits = 8'b00111100;
            1: bits = 8'b01100110;
            2: bits = 8'b00000110;
            3: bits = 8'b00011100;
            4: bits = 8'b00000110;
            5: bits = 8'b01100110;
            6: bits = 8'b00111100;
            default: bits = 0;
        endcase

        "4": case (row)
            0: bits = 8'b00001100;
            1: bits = 8'b00011100;
            2: bits = 8'b00101100;
            3: bits = 8'b01001100;
            4: bits = 8'b01111110;
            5: bits = 8'b00001100;
            6: bits = 8'b00001100;
            default: bits = 0;
        endcase

        "5": case (row)
            0: bits = 8'b01111110;
            1: bits = 8'b01100000;
            2: bits = 8'b01111100;
            3: bits = 8'b00000110;
            4: bits = 8'b00000110;
            5: bits = 8'b01100110;
            6: bits = 8'b00111100;
            default: bits = 0;
        endcase

        "6": case (row)
            0: bits = 8'b00111100;
            1: bits = 8'b01100110;
            2: bits = 8'b01100000;
            3: bits = 8'b01111100;
            4: bits = 8'b01100110;
            5: bits = 8'b01100110;
            6: bits = 8'b00111100;
            default: bits = 0;
        endcase

        "7": case (row)
            0: bits = 8'b01111110;
            1: bits = 8'b00000110;
            2: bits = 8'b00001100;
            3: bits = 8'b00011000;
            4: bits = 8'b00110000;
            5: bits = 8'b00110000;
            6: bits = 8'b00110000;
            default: bits = 0;
        endcase

        "8": case (row)
            0: bits = 8'b00111100;
            1: bits = 8'b01100110;
            2: bits = 8'b01100110;
            3: bits = 8'b00111100;
            4: bits = 8'b01100110;
            5: bits = 8'b01100110;
            6: bits = 8'b00111100;
            default: bits = 0;
        endcase

        "9": case (row)
            0: bits = 8'b00111100;
            1: bits = 8'b01100110;
            2: bits = 8'b01100110;
            3: bits = 8'b00111110;
            4: bits = 8'b00000110;
            5: bits = 8'b01100110;
            6: bits = 8'b00111100;
            default: bits = 0;
        endcase

        " ": bits = 8'b00000000;

        default: bits = 8'b00000000;
    endcase
end

endmodule