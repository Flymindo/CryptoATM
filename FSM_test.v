`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2020 12:08:02 PM
// Design Name: 
// Module Name: FSM_test
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


module FSM_test(

    );
    reg clk;
    reg [1:0] usr_input;
    reg [3:0] status_code;
    wire [15:0] current_state;
    wire [3:0] input_style_out;
    wire [15:0] state_led;
    
    parameter [3:0] 
        ACC_FOUND = 4'b0001,
        ACC_NOT_FOUND = 4'b0010,
        PIN_CORRECT = 4'b0011,
        PIN_INCORRECT = 4'b0100,
        AMT_VALID = 4'b0101,
        AMT_INVALID = 4'b0110,
        EXIT = 4'b0111,
        INPUT_COMPLETE = 4'b1000;
    
    parameter [1:0]
        BALANCE = 2'b00,
        CONVERT = 2'b01,
        WITHDRAW_OPTION = 2'b10,
        TRANSFER_OPTION = 2'b11;
    
    FSM state_test(.clk(clk), .usr_input(usr_input), .status_code(status_code), .current_state(current_state),
    .input_style_out(input_style_out), .state_led(state_led));
    
    initial begin
    
    clk = 0;
    
    #20 status_code = INPUT_COMPLETE;
    #20 status_code = ACC_NOT_FOUND; // back to idle
    #20 status_code = INPUT_COMPLETE;
    #20 status_code = ACC_FOUND; // advance to PIN_INPUT
    #20 status_code = PIN_INCORRECT; // back to idle
    #20 status_code = INPUT_COMPLETE;
    #20 status_code = ACC_FOUND;
    #20 status_code = PIN_CORRECT; // advance to MENU
    
    #20 status_code = EXIT; // exit to idle
    #20 status_code = INPUT_COMPLETE;
    #20 status_code = ACC_FOUND;
    #20 status_code = PIN_CORRECT; // advance to MENU
    
    #20 usr_input = BALANCE;
    #20 status_code = EXIT;
    
    // successful conversion
    #20 usr_input = CONVERT;
    #20 status_code = INPUT_COMPLETE;
    #20 status_code = AMT_VALID;
    #20 status_code = INPUT_COMPLETE;
    #20 status_code = EXIT;
    
    //successful withdrawal
    #20 usr_input = WITHDRAW_OPTION;
    #20 status_code = INPUT_COMPLETE;
    #20 status_code = AMT_VALID;
    #20 status_code = EXIT;
    
    // unsuccessful withdrawal
    #20 usr_input = WITHDRAW_OPTION;
    #20 status_code = INPUT_COMPLETE;
    #20 status_code = AMT_INVALID;
    #20 status_code = EXIT;
    
    // successful Transfer
    
    #20 usr_input = TRANSFER_OPTION;
    #20 status_code = ACC_FOUND;
    #20 status_code = INPUT_COMPLETE;
    #20 status_code = AMT_VALID;
    #20 status_code = EXIT;
    
    // unsuccessful transfer
    
    #20 usr_input = TRANSFER_OPTION;
    #20 status_code = ACC_NOT_FOUND;
    #20 status_code = EXIT;
    
    
    
    end
    
    always 
        #10 clk = ~clk;
    
endmodule
