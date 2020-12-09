`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/09 20:46:34
// Design Name: 
// Module Name: display
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


module display(
    input clk, BTNU,
    input [15:0] state,
    input [15:0] balance_dollars_out,
    input [15:0] balance_btc,
    input [15:0] balance_eth,
    input [15:0] balance_xrp,
    input [15:0] balance_ltc,
    output  reg[7:0] AN,
    output  reg[6:0] led
    );
    
    wire [7:0] AN_menu, AN_const, AN_mov,AN_bal;
    wire [6:0] led_menu, led_const, led_mov, led_bal;
    
    const_instruction inst_const(clk, state, AN_const,led_const);
    menu menu_selection(clk,BTNU, AN_menu, led_menu);
    moving_ins mi(clk, state, AN_mov, led_mov);
    display_balance db1(clk,BTNU,balance_dollars_out,balance_btc,balance_eth,balance_xrp,balance_ltc, AN_bal,led_bal);
    

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
    
    
    always@(*)
    begin
        case(state)
            IDLE: 
            begin
                AN = AN_const;
                led = led_const;
            end
            ACC_NUM: //ACC_NUM
            begin
                AN = AN_mov;
               led = led_mov;
            end
            PIN_INPUT: //PIN_INPUT
            begin
               AN = AN_mov;
               led = led_mov;
            end
            MENU:
            begin
                AN = AN_menu;
                led = led_menu;
            end
            SHOW_BALANCES: //SHOW_BALANCES
            begin
                AN = AN_bal;
                led = led_bal;
            end
            CONVERT_CURRENCY: //CONVERT_CURRENCY
            begin
               AN = AN_mov;
               led = led_mov;
            end
            SELECT_CURRENCY_CONVERT_1: //SELECT_CURRENCY1
            begin
               AN = AN_mov;
               led = led_mov;
            end
            SELECT_CURRENCY_CONVERT_2: //SELECT_CURRENCY2
            begin
                AN = AN_mov;
               led = led_mov;
            end
            WITHDRAW: //WITHDRAW
            begin
                AN = AN_mov;
               led = led_mov;
            end
            SELECT_AMOUNT_WITHDRAW: //SELECT_AMOUNT_WITHDRAW
            begin
                AN = AN_mov;
                led = led_mov;
            end
            TRANSFER: //TRANSFER
            begin
                AN = AN_mov;
                led = led_mov;
            end
            SELECT_CURRENCY_TRANSFER: //SELECT_CURRENCY_TRANSFER
            begin
                AN = AN_mov;
                led = led_mov;
            end
            SELECT_AMOUNT_TRANSFER: //SELECT_AMOUNT_TRNASFER
            begin
                AN = AN_mov;
                led = led_mov;
            end
            ERROR:
            begin
                AN = AN_const;
               led = led_const;
            end
            SUCCESS:
            begin
                AN = AN_const;
                led = led_const;
            end
        endcase
    end
    
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
endmodule
