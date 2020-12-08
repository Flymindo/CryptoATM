`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2020 11:36:48 AM
// Design Name: 
// Module Name: user_input
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


// PROGRAM TO SEND READY SIGNAL FOR EVERYTHING
// used after asciitobinary.v


module user_input(
    input clk,
    input  [7:0] ascii_code,
    input  [3:0] input_style_out,
    input [15:0] cstate,
    output reg [3:0] status_code_out,
    output reg [31:0] pswd,
    output reg [31:0] acct,
    output reg [1:0] usr_input_out,
    output reg [2:0] currency_type_out
    );
    reg[3:0] a; // asciitobinary conversion temporary reg

    parameter [2:0]
        USD = 3'b000,
        BTC = 3'b001,
        ETH = 3'b010,
        XRP = 3'b011,
        LTC = 3'b100;
        
    parameter [3:0] 
        ACC_FOUND = 4'b0001,
        ACC_NOT_FOUND = 4'b0010,
        PIN_CORRECT = 4'b0011,
        PIN_INCORRECT = 4'b0100,
        AMT_VALID = 4'b0101,
        AMT_INVALID = 4'b0110,
        EXIT = 4'b0111,
        INPUT_COMPLETE = 4'b1000;
        
    parameter [3:0]
        SINGLE_KEY = 4'b0001,
        ACC_NUMBER = 4'b0010,
        PIN_NUMBER = 4'b0011,
        MENU_SELECTION = 4'b0100,
        CURRENCY_TYPE = 4'b0101,
        CURRENCY_AMOUNT = 4'b0110;
        
    parameter [1:0]
        BALANCE = 2'b00,
        CONVERT = 2'b01,
        WITHDRAW_OPTION = 2'b10,
        TRANSFER_OPTION = 2'b11;
    
    reg [2:0] count =0;
    
    always @(posedge clk) begin
    
    case(ascii_code)
        8'h71: begin   // q
            status_code_out = EXIT;
            end
    endcase
    
    'define CLOCK_FREQ 100000000 // 100 MHz clk
    'define TIME_DELAY 3 // seconds
    reg [31:0] timer=0;

    assign do_something = (timer==`CLOCK_FREQ*`TIME_DELAY); //3 second pause
    
    case(input_style_out)
        ACC_NUMBER: begin
        if (ascii_code !== 8'h2A) begin
            //Concatenation code for ACC_NUMBER  
            if(count == 0 && status_code_out !== INPUT_COMPLETE) begin
                acct <= 0;
                count <= count+1'b1;
                asciitobinary(ascii_code[7:0],a,clk, count, current_state, status_code_out); 
                acct <= a[3:0]; // 0 is the pin's LSB
            end
            else if(count > 0 && count < 4) begin
                count <= count+1'b1;
                asciitobinary(ascii_code[7:0],a,clk, count, current_state, status_code_out);
                acct  = {a[3:0],acct};
            end
            else if(count >= 4) begin                 
                always @(posedge clk) begin
                    timer <= timer + 1'b1; // waits for 3 seconds       
                    // ready signal using enter key
                    if(ascii_code == 8'h0D)         // Enter button pressed
                        begin
                            status_code_out = INPUT_COMPLETE;
                        end
                end
                count <= 0;
            end  
        end
        end
        
        PIN_NUMBER: begin
        if (ascii_code !== 8'h2A) begin // if code is non-default
            if(count == 0 && status_code_out !== INPUT_COMPLETE) begin // digit1
                pswd <= 0;
                count <= count+1'b1;
                asciitobinary(ascii_code[7:0],a,clk, count, current_state, status_code_out);
                pswd <= a[3:0]; // fill the LSB of output   
            end
            else if(count > 0 && count < 4) begin
                count <= count + 1'b1;
                asciitobinary(ascii_code[7:0],a,clk,count, current_state, status_code_out);
                pswd  = {a[3:0], pswd};
            end
            else if(count >= 4) begin
                always @(posedge clk) begin
                    timer <= timer + 1'b1; // waits for 3 seconds       
                    // ready signal using enter key
                    if(ascii_code == 8'h0D)         // Enter button pressed
                        begin
                            status_code_out = INPUT_COMPLETE;
                        end
                end
                count <= 0;
            end
            if(ascii_code == 8'h0D)         // Enter button pressed
                begin
                    status_code_out = INPUT_COMPLETE;
                end
        end
        end
        
        MENU_SELECTION: begin
            case(ascii_code)
                8'h62: begin                               // b key (balance)
                    usr_input_out = BALANCE;
                    end
                8'h63: begin                               // c (convert currency)
                    usr_input_out = CONVERT;
                    end
                8'h77: begin                               // w (withdraw)
                    usr_input_out = WITHDRAW_OPTION;
                    end
                8'h74: begin                              // t (transfer)
                    usr_input_out = TRANSFER_OPTION;
                    end
            endcase
            always @(posedge clk) begin
                    timer <= timer + 1'b1; // waits for 3 seconds       
                    // ready signal using enter key
                    if(ascii_code == 8'h0D)         // Enter button pressed
                        begin
                            status_code_out = INPUT_COMPLETE;
                        end
                end
        end 
  
        SINGLE_KEY: begin                         
                always @(posedge clk) begin
                    timer <= timer + 1'b1; // waits for 3 seconds       
                    // ready signal using enter key
                    if(ascii_code == 8'h0D)         // Enter button pressed
                        begin
                            status_code_out = INPUT_COMPLETE;
                        end
                end            
        end
                
        CURRENCY_TYPE: begin            ///1 to 5 cases         ///  currency_type_out = ascii hex   ///ready signal
            case(ascii_code)
                8'h31: begin                            // 1 - USD
                    currency_type_out = USD;
                    end
                8'h32: begin                            // 2 - BTC
                    currency_type_out = BTC;
                    end
                8'h33: begin                           // 3 - ETH
                    currency_type_out = ETH;
                    end
                8'h34: begin                           // 4 - XRP
                    currency_type_out = XRP;
                    end
                8'h35: begin                           // 5 - LTC
                    currency_type_out = LTC;
                    end
            endcase
            always @(posedge clk) begin
                    timer <= timer + 1'b1; // waits for 3 seconds       
                    // ready signal using enter key
                    if(ascii_code == 8'h0D)         // Enter button pressed
                        begin
                            status_code_out = INPUT_COMPLETE;
                        end
                end
        end
            
            
        CURRENCY_AMOUNT: begin       
        
              //// until max out 8 digits or they hit enter /////////////////////////////////
              
            always @(posedge clk) begin
                    timer <= timer + 1'b1; // waits for 3 seconds       
                    // ready signal using enter key
                    if(ascii_code == 8'h0D)         // Enter button pressed
                        begin
                            status_code_out = INPUT_COMPLETE;
                        end
                end
        end
             
             
             

    endcase
    end
    
    
endmodule








