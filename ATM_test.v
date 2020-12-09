`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2020 04:55:54 PM
// Design Name: 
// Module Name: ATM_test
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


module ATM_test(

    );
    
    reg clk;
    reg [11:0] accNumber;
    reg [3:0] pin;
    reg [15:0] current_state;
    reg [1:0] menuOption;
    reg [2:0] currency_type_in;
    reg [2:0] currency_type_2_in;
    reg [10:0] amount;
    reg ready;
    reg [11:0] destinationAcc;
    wire [15:0] balance_dollars_out;
    wire [15:0] balance_btc_out;
    wire [15:0] balance_eth_out;
    wire [15:0] balance_xrp_out;
    wire [15:0] balance_ltc_out;
    wire [3:0] status_code;
    
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
    
    parameter [2:0]
        USD = 3'b000,
        BTC = 3'b001,
        ETH = 3'b010,
        XRP = 3'b011,
        LTC = 3'b100;
    
    ATM atm_test(.clk(clk), .accNumber(accNumber), .pin(pin), .current_state(current_state), .menuOption(menuOption), .currency_type_in(currency_type_in),
    .currency_type_2_in(currency_type_2_in), .amount(amount), .ready(ready), .destinationAcc(destinationAcc), .balance_dollars_out(balance_dollars_out), .balance_btc_out(balance_btc_out), 
    .balance_eth_out(balance_eth_out), .balance_xrp_out(balance_xrp_out), .balance_ltc_out(balance_ltc_out), .status_code(status_code));
    
    initial begin
    
    clk = 0;
    accNumber = 12'd2749;
    pin = 4'b0000;
    current_state = ACC_NUM;
    ready = 0;
    
    #20 ready = 1;
    #20 ready = 0;
    #50 current_state = PIN_INPUT;
    #20 ready = 1;
    #20 ready = 0;
    
    
    #50 current_state = SELECT_CURRENCY_CONVERT_1;
    #50 amount = 50;
    #20 ready = 1;
    #20 ready = 0;
    
    #50 current_state = SELECT_CURRENCY_CONVERT_2;
    #50 currency_type_in = ETH;
    #50 currency_type_2_in = USD;
    #50 amount = 1;
    #20 ready = 1;
    #20 ready = 0;
    
    #50 current_state = SELECT_AMOUNT_WITHDRAW;
    #50 currency_type_in = USD;
    #50 amount = 100;
    #20 ready = 1;
    #20 ready = 0;
    
    #50 current_state = TRANSFER;
    #50 destinationAcc = 12'd2175;
    #20 ready = 1;
    #20 ready = 0;
    
    #50 current_state = SELECT_AMOUNT_TRANSFER;
    #20 currency_type_in = USD;
    #20 amount = 100;
    #20 ready = 1;
    #20 ready = 0;
    
    
    #50 current_state = IDLE;
    #50 accNumber = 12'd2175;
    #50 pin = 4'b0001;
    
    #50 current_state = ACC_NUM;
    #20 ready = 1;
    #20 ready = 0;
    
    #50 current_state = PIN_INPUT;
    #20 ready = 1;
    #20 ready = 0;
    
    #50 current_state = SHOW_BALANCES;
    
    end
    
    always 
        #10 clk = ~clk;
    
endmodule
