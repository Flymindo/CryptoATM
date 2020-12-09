`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/09 21:02:31
// Design Name: 
// Module Name: moving_ins
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


module moving_ins(
    input clk,
    input [15:0] state,
    output reg [7:0] AN,
    output reg [6:0] led
    );
    wire s_clock;
    wire [39:0] inst_acc_num,inst_pin_num,inst_enter_amount,inst_select_currency;
    
    wire [7:0] AN1,AN2,AN3,AN4;
    wire [6:0] led1,led2,led3,led4;
    

    reg rst1,rst2,rst3,rst4;

    
    sec_clock sec(clk,s_clock);

    inst_input_acc_num iian(s_clock,rst1,inst_acc_num);
    inst_enter_pin_num iepn(s_clock,rst2,inst_pin_num);
    inst_enter_amount iea(s_clock, rst3, inst_enter_amount);
    inst_select_currency isc(s_clock, rst4, inst_select_currency);
    
    
    
    
    instruction_seven_seg_display issd1(clk,inst_acc_num,AN1,led1);
    instruction_seven_seg_display issd2(clk,inst_pin_num,AN2,led2);
    instruction_seven_seg_display issd3(clk,inst_enter_amount,AN3,led3);
    instruction_seven_seg_display issd4(clk,inst_select_currency,AN4,led4);


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
        ACC_NUM:
            begin
                AN = AN1;
                {rst1,rst2,rst3,rst4} = 4'b0111;
                led = led1;
            end 
        PIN_INPUT:
            begin
                AN = AN2;
                {rst1,rst2,rst3,rst4} = 4'b1011;
                led = led2;
            end
        CONVERT_CURRENCY:
            begin
                AN = AN4;
                {rst1,rst2,rst3,rst4} = 4'b1110;
                led = led4;
            end
        SELECT_CURRENCY_CONVERT_2:
            begin
                AN = AN4;
                {rst1,rst2,rst3,rst4} = 4'b1110;
                led = led4;
            end    
        SELECT_CURRENCY_CONVERT_1:
            begin
                AN = AN3;
                {rst1,rst2,rst3,rst4} = 4'b1101;
                led = led3;
            end
        WITHDRAW:
            begin
                AN = AN3;
                {rst1,rst2,rst3,rst4} = 4'b1101;
                led = led3;
            end
        SELECT_AMOUNT_WITHDRAW:
            begin
                AN = AN3;
                {rst1,rst2,rst3,rst4} = 4'b1101;
                led = led3;
            end
        TRANSFER:
            begin
                AN = AN1;
                {rst1,rst2,rst3,rst4} = 4'b0111;
                led = led1;
            end
         SELECT_CURRENCY_TRANSFER:
            begin
                AN = AN4;
                {rst1,rst2,rst3,rst4} = 4'b1110;
                led = led4;
            end
         SELECT_AMOUNT_TRANSFER:
            begin
                AN = AN3;
                {rst1,rst2,rst3,rst4} = 4'b1101;
                led = led3;
            end   
        default:
                 {rst1,rst2,rst3,rst4} = 4'b1111;
        endcase
        
    end
    
endmodule
