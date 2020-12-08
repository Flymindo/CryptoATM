`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2015 09:06:31 AM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: Nexys4DDR
// Tool Versions: 
// Description: This project takes keyboard input from the PS2 port,
//  and outputs the keyboard scan code to the 7 segment display on the board.
//  The scan code is shifted left 2 characters each time a new code is
//  read.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input CLK100MHZ,
    input PS2_CLK,
    input PS2_DATA,
    output [6:0]SEG,
    output [7:0]AN,
    output DP,
    output UART_TXD,
    );
    
reg CLK50MHZ=0; 
wire[15:0] state; // initialize to IDLE = 16'b0000000000000001 ?
wire inc_state;
wire[15:0] password; // password register
wire[15:0] username; // account register
wire [31:0] scancode;
wire[7:0] ascii_code;
wire[3:0] binary_code; // 0-9 num converted to binary
wire display_enable;
wire input_style_out;
wire [2:0] currency_type_out;
wire [1:0] usr_input_out;
wire [3:0]status_code_out;


    // Parameter for status codes in state transitions (status_code)
    parameter [3:0] 
        ACC_FOUND = 4'b0001,
        ACC_NOT_FOUND = 4'b0010,
        PIN_CORRECT = 4'b0011,
        PIN_INCORRECT = 4'b0100,
        AMT_VALID = 4'b0101,
        AMT_INVALID = 4'b0110,
        EXIT = 4'b0111,
        INPUT_COMPLETE = 4'b1000;
        
    // Parameter for Input style (Pretty sure these will work for all state transitions/input requirements, let me know though)
    parameter [3:0]
        SINGLE_KEY = 4'b0001,
        ACC_NUMBER = 4'b0010,
        PIN_NUMBER = 4'b0011,
        MENU_SELECTION = 4'b0100,
        CURRENCY_TYPE = 4'b0101,
        CURRENCY_AMOUNT = 4'b0110;
        
    parameter [4:0] // I made this encoding scheme so i could light up debug LEDs but there are too many states lol
                     // These will probably change but wont affect any other modules
        IDLE = 5'b00001,
        ACC_NUM = 5'b00010,
        PIN_INPUT = 5'b00011,
        MENU = 5'b00100,
        SHOW_BALANCES = 5'b00101,
        CONVERT_CURRENCY = 5'b00110,
        SELECT_CURRENCY_CONVERT_1 = 5'b00111,
        SELECT_CURRENCY_CONVERT_2 = 5'b01000,
        WITHDRAW = 5'b01001,
        SELECT_AMOUNT_WITHDRAW = 5'b01010,
        TRANSFER = 5'b01011,
        SELECT_CURRENCY_TRANSFER = 5'b01100,
        SELECT_AMOUNT_TRANSFER = 5'b01101,
        ERROR = 5'b01110,
        SUCCESS = 5'b01111;
        
    initial state = IDLE;

always @(posedge(CLK100MHZ))begin
    CLK50MHZ<=~CLK50MHZ;
end

PS2Receiver keyboard (
.clk(CLK50MHZ),
.kclk(PS2_CLK),
.kdata(PS2_DATA),
.keycodeout(scancode[31:0])
);

ascii_decoder adec(.scan_code(scancode[7:0]), .ascii_code(ascii_code));

// user_input contains asciitobinary conversion for acct IDs, PIN pswd #.
user_input #(.ACC_FOUND(4'b0001),
        .ACC_NOT_FOUND(4'b0010),
        .PIN_CORRECT(4'b0011),
        .PIN_INCORRECT(4'b0100),
        .AMT_VALID(4'b0101),
        .AMT_INVALID(4'b0110),
        .EXIT(4'b0111),
        .INPUT_COMPLETE(4'b1000),
        .SINGLE_KEY(4'b0001),
        .ACC_NUMBER(4'b0010),
        .PIN_NUMBER(4'b0011),
        .MENU_SELECTION(4'b0100),
        .CURRENCY_TYPE(4'b0101),
        .CURRENCY_AMOUNT(4'b0110),
        .IDLE(5'b00001),
        .ACC_NUM(5'b00010),
        .PIN_INPUT(5'b00011),
        .MENU(5'b00100),
        .SHOW_BALANCES(5'b00101),
        .CONVERT_CURRENCY(5'b00110),
        .SELECT_CURRENCY_CONVERT_1(5'b00111),
        .SELECT_CURRENCY_CONVERT_2(5'b01000),
        .WITHDRAW(5'b01001),
        .SELECT_AMOUNT_WITHDRAW(5'b01010),
        .TRANSFER(5'b01011),
        .SELECT_CURRENCY_TRANSFER(5'b01100),
        .SELECT_AMOUNT_TRANSFER(5'b01101),
        .ERROR(5'b01110),
        .SUCCESS(5'b01111))
        usr(
    .clk(CLK100MHZ),
    .ascii_code(binary_code[3:0]),
    .cstate(state[15:0]),
    .status_code_out(status_code_out),
    .pswd(password),
    .acct(username),
    .usr_input_out(usr_input_out),
    .currency_type_out(currency_type_out)
    );

// this wrappper needs modified, idk how pswd/acct should be passed
FSM #(.ACC_FOUND(4'b0001),
        .ACC_NOT_FOUND(4'b0010),
        .PIN_CORRECT(4'b0011),
        .PIN_INCORRECT(4'b0100),
        .AMT_VALID(4'b0101),
        .AMT_INVALID(4'b0110),
        .EXIT(4'b0111),
        .INPUT_COMPLETE(4'b1000),
        .SINGLE_KEY(4'b0001),
        .ACC_NUMBER(4'b0010),
        .PIN_NUMBER(4'b0011),
        .MENU_SELECTION(4'b0100),
        .CURRENCY_TYPE(4'b0101),
        .CURRENCY_AMOUNT(4'b0110),
        .IDLE(5'b00001),
        .ACC_NUM(5'b00010),
        .PIN_INPUT(5'b00011),
        .MENU(5'b00100),
        .SHOW_BALANCES(5'b00101),
        .CONVERT_CURRENCY(5'b00110),
        .SELECT_CURRENCY_CONVERT_1(5'b00111),
        .SELECT_CURRENCY_CONVERT_2(5'b01000),
        .WITHDRAW(5'b01001),
        .SELECT_AMOUNT_WITHDRAW(5'b01010),
        .TRANSFER(5'b01011),
        .SELECT_CURRENCY_TRANSFER(5'b01100),
        .SELECT_AMOUNT_TRANSFER(5'b01101),
        .ERROR(5'b01110),
        .SUCCESS(5'b01111))
    UUT(
    .clk(CLK100MHZ),
    .inc_state(inc_state), //debug button to progress state
    .usr_input(ascii_code), //Input from user (probably going to change as the input format is still up in the air
    .status_code(status_code_out), //Status from middle module for use in progressing states that require more than a simple input 
    .current_state(cstate), //Current state code
    .display_enable(display_enable), //Display output parameter that will have to get configured
    .input_style_out(input_style_out),
    .state_led(state_led) //
    );
    

endmodule
