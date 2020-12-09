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
    input clk,BTNU,
    input [3:0] states,
    output [7:0] AN,
    output [6:0] led
    );
    reg[39:0] temp_instruction;
    wire[39:0] instruction;
    
    wire[39:0] inst_acc_num;
    reg [2:0] button_op;
    wire up;


    instruction_seven_seg_display isvd(clk, instruction, AN, led);
        
    debounce d1(BTNU,clk,up);
    
    
    always@(posedge up)
    begin
        if(up)
        begin
            if (button_op == 3'b000)
                button_op = 3'b100;
            else
                button_op <= button_op - 1'b1;
        end
    end
    
    
    parameter [39:0]
    INST_IDLE = 40'b0000010111001010110000011011110110100101, //welcome
    INST_ERROR = 40'b0000000000001011001010010011111001000000,
    INST_SUCCESS = 40'b0000010011101010001100011001011001110011,
    INST_DOLLAR = 40'b0000000000000000000000000101011001100100,
    INST_BTC = 40'b0000000000000000000000000000101010000011,
    INST_ETH = 40'b0000000000000000000000000001011010001000,
    INST_XRP = 40'b0000000000000000000000000110001001010000,
    INST_LTC = 40'b0000000000000000000000000011001010000011,
    temporary = 40'b0000100001000010000100001000010000100001;
    
    reg reset;
    
    always@(*)
    begin
        case(states)
            4'b0000: temp_instruction = INST_IDLE;
            4'b0110:
                begin
                    if(button_op == 3'b000)
                        temp_instruction = INST_DOLLAR;
                    else if (button_op == 3'b001)
                        temp_instruction = INST_BTC;
                    else if (button_op == 3'b010)
                        temp_instruction = INST_ETH;
                        else if (button_op == 3'b011)
                        temp_instruction = INST_XRP;
                        else if (button_op == 3'b100)
                        temp_instruction = INST_LTC;
                end
            4'b1011:
                begin
                    if(button_op == 3'b000)
                        temp_instruction = INST_DOLLAR;
                    else if (button_op == 3'b001)
                        temp_instruction = INST_BTC;
                    else if (button_op == 3'b010)
                        temp_instruction = INST_ETH;
                        else if (button_op == 3'b011)
                        temp_instruction = INST_XRP;
                        else if (button_op == 3'b100)
                        temp_instruction = INST_LTC;
                end
            4'b1101: temp_instruction = INST_ERROR;
            4'b1110: temp_instruction = INST_SUCCESS;
        endcase
    end
    assign instruction = temp_instruction;
endmodule
