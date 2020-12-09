`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/09 17:21:36
// Design Name: 
// Module Name: const_instruction
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


module const_instruction(
    input clk,
    input [15:0] states,
    output [7:0] AN,
    output [6:0] led
    );
    reg[39:0] temp_instruction;
    wire[39:0] instruction;
    
    wire[39:0] inst_acc_num;



    instruction_seven_seg_display isvd(clk, instruction, AN, led);
        
    parameter [15:0] // I made this encoding scheme so i could light up debug LEDs but there are too many states lol
                 // These will probably change but wont affect any other modules
    IDLE = 16'b0000000000000001,
    ACC_NUM = 16'b0000000000000010,
    PIN_INPUT = 16'b0000000000000100,
    MENU = 16'b0000000000001000,
    SHOW_BALANCES = 16'b0000000000010000,
    CONVERT_CURRENCY = 16'b0000000000100000,
    SELECT_CURRENCY_CONVERT_1 = 16'b0000000001000000,
    SELECT_CURRENCY_CONVERT_2 = 16'b0000000010000000,
    WITHDRAW = 16'b0000000100000000,
    SELECT_AMOUNT_WITHDRAW = 16'b0000001000000000,
    TRANSFER = 16'b0000010000000000,
    SELECT_CURRENCY_TRANSFER = 16'b0000100000000000,
    SELECT_AMOUNT_TRANSFER = 16'b0001000000000000,
    ERROR = 16'b0010000000000000,
    SUCCESS = 16'b0100000000000000;
    
    
    parameter [39:0]
    INST_IDLE = 40'b0000010111001010110000011011110110100101, //welcome
    INST_ERROR = 40'b0000000000001011001010010011111001000000,
    INST_SUCCESS = 40'b0000010011101010001100011001011001110011;
    

    
    always@(*)
    begin
        case(states)
            IDLE: temp_instruction = INST_IDLE;
            ERROR: temp_instruction = INST_ERROR;
            SUCCESS: temp_instruction = INST_SUCCESS;
        endcase
    end
    assign instruction = temp_instruction;
endmodule
