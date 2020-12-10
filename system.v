`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2020 09:12:53 PM
// Design Name: 
// Module Name: system
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


module system(
    input clk,
    input PS2_CLK,
    input PS2_DATA,
    input BTNU,
    output [6:0] SEG,
    output [7:0] AN,
    output [15:0] state_led
    );
    
    
    wire [3:0] accNumber;
    wire [3:0] pin;
    wire [15:0] current_state;
    wire [1:0] menuOption;
    wire [2:0] currency_type_in;
    wire [2:0] currency_type_2_in;
    wire [31:0] amount;
    wire ready;
    wire [3:0] destinationAcc;
    wire [15:0] balance_dollars_out;
    wire [15:0] balance_btc_out;
    wire [15:0] balance_eth_out;
    //wire [31:0] balance_xrp_out;
    //wire [31:0] balance_ltc_out;
    wire [3:0] status_code;
    wire [3:0] status_code_buffer;
    
    wire [3:0] input_style_out;
    
    reg CLK50MHZ=0;
    wire [31:0] scancode;
    wire[7:0] ascii_code; 
    
    always @(posedge(clk))begin
    CLK50MHZ<=~CLK50MHZ;
    end
    
    //(*dont_touch = "true"*) 
    PS2Receiver keyboard (
    .clk(CLK50MHZ),
    .kclk(PS2_CLK),
    .kdata(PS2_DATA),
    .keycodeout(scancode[31:0])
    );

    //(*dont_touch = "true"*) 
    ascii_decoder adec(.scan_code(scancode[7:0]), .ascii_code(ascii_code));
    
    
    //(*dont_touch = "true"*) 
    FSM statemachine(.clk(clk), .usr_input(menuOption), .status_code(status_code), .current_state(current_state),
    .input_style_out(input_style_out), .state_led(state_led));
    
   //(*dont_touch = "true"*) 
   ATM atmlogic(.clk(clk), .accNumber(accNumber), .pin(pin), .current_state(current_state), .menuOption(menuOption),
    .currency_type_in(currency_type_in), .currency_type_2_in(currency_type_2_in), .amount(amount), .ready(ready),
    .destinationAcc(destinationAcc), .status_code_in(status_code_buffer), .balance_dollars_out(balance_dollars_out), .balance_btc_out(balance_btc_out),
    .balance_eth_out(balance_eth_out), .status_code(status_code));
    
   //(*dont_touch = "true"*) 
   user_input inputmodule(.clk(clk), .ascii_code(ascii_code), .input_style_out(input_style_out), .current_state(current_state), .ready(ready),
    .status_code_out(status_code_buffer), .pswd(pin), .acct(accNumber), .usr_input_out(menuOption), .currency_type_out(currency_type_in),
    .currency_type_2_out(currency_type_2_in), .destinationAcc(destinationAcc));
    
    
    //(*dont_touch = "true"*) 
    display outputmodule(.clk(clk), .BTNU(BTNU), .state(current_state), .balance_dollars_out(balance_dollars_out),
    .balance_btc(balance_btc_out), .balance_eth(balance_eth_out), .balance_xrp(balance_xrp_out), .balance_ltc(balance_ltc_out),
    .AN(AN), .led(SEG));
    
endmodule
