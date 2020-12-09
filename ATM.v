`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2020 03:16:47 PM
// Design Name: 
// Module Name: ATM
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


module ATM(
    input clk,
    input [11:0] accNumber,
    input [3:0] pin,
    input [15:0] current_state,
    input [1:0] menuOption,
    input [2:0] currency_type_in,
    input [2:0] currency_type_2_in,
    input [10:0] amount,
    input ready,
    input [11:0] destinationAcc,
    //output reg [10:0] balance,
    output [15:0] balance_dollars_out,
    output [15:0] balance_btc_out,
    output [15:0] balance_eth_out,
    output [15:0] balance_xrp_out,
    output [15:0] balance_ltc_out,
    output [3:0] status_code
    );
    
    parameter 
        FIND = 1'b0,
        AUTHENTICATE = 1'b1;
        
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
    
    parameter [3:0] 
        ACC_FOUND = 4'b0001,
        ACC_NOT_FOUND = 4'b0010,
        PIN_CORRECT = 4'b0011,
        PIN_INCORRECT = 4'b0100,
        AMT_VALID = 4'b0101,
        AMT_INVALID = 4'b0110,
        EXIT = 4'b0111,
        INPUT_COMPLETE = 4'b1000;
    
    // Initialize and Fill all currency balances
    reg [15:0] balance_database [0:9][0:4];
    initial begin
    balance_database[0][0] = 16'd500;
    balance_database[1][0] = 16'd500;
    balance_database[2][0] = 16'd500;
    balance_database[3][0] = 16'd500;
    balance_database[4][0] = 16'd500;
    balance_database[5][0] = 16'd500;
    balance_database[6][0] = 16'd500;
    balance_database[7][0] = 16'd500;
    balance_database[8][0] = 16'd500;
    balance_database[9][0] = 16'd500;
    
    balance_database[0][1] = 16'd5;
    balance_database[1][1] = 16'd5;
    balance_database[2][1] = 16'd5;
    balance_database[3][1] = 16'd5;
    balance_database[4][1] = 16'd5;
    balance_database[5][1] = 16'd5;
    balance_database[6][1] = 16'd5;
    balance_database[7][1] = 16'd5;
    balance_database[8][1] = 16'd5;
    balance_database[9][1] = 16'd5;
    
    balance_database[0][2] = 16'd10;
    balance_database[1][2] = 16'd10;
    balance_database[2][2] = 16'd10;
    balance_database[3][2] = 16'd10;
    balance_database[4][2] = 16'd10;
    balance_database[5][2] = 16'd10;
    balance_database[6][2] = 16'd10;
    balance_database[7][2] = 16'd10;
    balance_database[8][2] = 16'd10;
    balance_database[9][2] = 16'd10;
    
    balance_database[0][3] = 16'd100;
    balance_database[1][3] = 16'd100;
    balance_database[2][3] = 16'd100;
    balance_database[3][3] = 16'd100;
    balance_database[4][3] = 16'd100;
    balance_database[5][3] = 16'd100;
    balance_database[6][3] = 16'd100;
    balance_database[7][3] = 16'd100;
    balance_database[8][3] = 16'd100;
    balance_database[9][3] = 16'd100;
    
    balance_database[0][4] = 16'd10;
    balance_database[1][4] = 16'd10;
    balance_database[2][4] = 16'd10;
    balance_database[3][4] = 16'd10;
    balance_database[4][4] = 16'd10;
    balance_database[5][4] = 16'd10;
    balance_database[6][4] = 16'd10;
    balance_database[7][4] = 16'd10;
    balance_database[8][4] = 16'd10;
    balance_database[9][4] = 16'd10;
    
    end
    
    reg [15:0] conversion_database [0:4][0:4];
    initial begin
    //USD
    conversion_database[0][0] = 1;
    conversion_database[0][1] = 0.00053;
    conversion_database[0][2] = 0.001753;
    conversion_database[0][3] = 1.74;
    conversion_database[0][4] = 0.012766;
    
    //BTC
    conversion_database[1][0] = 18785;
    conversion_database[1][1] = 1;
    conversion_database[1][2] = 33;
    conversion_database[1][3] = 32805;
    conversion_database[1][4] = 240;
    
    //ETH
    conversion_database[2][0] = 570;
    conversion_database[2][1] = 0.03;
    conversion_database[2][2] = 1;
    conversion_database[2][3] = 991;
    conversion_database[2][4] = 7.29;
    
    //XRP
    conversion_database[3][0] = 0.575738;
    conversion_database[3][1] = 0.000031;
    conversion_database[3][2] = 0.001004;
    conversion_database[3][3] = 1;
    conversion_database[3][4] = 0.007316;
    
    //LTC
    conversion_database[4][0] = 78.26;
    conversion_database[4][1] = 0.004160;
    conversion_database[4][2] = 0.137396;
    conversion_database[4][3] = 136.75;
    conversion_database[4][4] = 1;
    end
    
    wire [3:0] accIndex;
    wire [3:0] accIndexFind;
    wire [3:0] destinationAccIndex;
    wire isAuthenticated;
    wire wasFound;
    wire accFound;
    
    reg deAuth = 1'b0;
    
    reg [15:0] balance_dollars;
    reg [15:0] balance_btc;
    reg [15:0] balance_eth;
    reg [15:0] balance_xrp;
    reg [15:0] balance_ltc;
    
    reg [1:0] currency_type = 2'b00;
    reg [1:0] currency_type_second = 2'b00;
    reg [3:0] status_code_reg;
    
    authenticator authAccNumberModule(accNumber, pin, AUTHENTICATE, deAuth, isAuthenticated, accIndex);
    authenticator accFinder(accNumber, 0, FIND, deAuth, accFound, accIndexFind);
    authenticator findAccNumberModule(destinationAcc, 0, FIND, deAuth, wasFound, destinationAccIndex);
    
    always @(posedge clk) begin
    
    case (current_state)
        
        IDLE: begin
            deAuth = 1'b1;
            #20;
        end
        
        ACC_NUM: begin
            if ((ready == 1'b1) & accFound)
                status_code_reg = ACC_FOUND;
            else if ((ready == 1'b1) & ~accFound)
                status_code_reg = ACC_NOT_FOUND;
        end
        
        PIN_INPUT: begin
            if ((ready == 1'b1) & isAuthenticated)
                status_code_reg = PIN_CORRECT;
            else if ((ready == 1'b1) & ~isAuthenticated)
                status_code_reg = PIN_INCORRECT;
        end
        
        
        SHOW_BALANCES: begin
            balance_dollars = balance_database[accIndex][0];
            balance_btc = balance_database[accIndex][1];
            balance_eth = balance_database[accIndex][2];
            balance_xrp = balance_database[accIndex][3];
            balance_ltc = balance_database[accIndex][4];
        end
        
        SELECT_CURRENCY_CONVERT_1: begin
            if ((ready == 1'b1) & (amount <= balance_database[accIndex][currency_type_in]))
                status_code_reg = AMT_VALID;
            else if ((ready == 1'b1) & (amount > balance_database[accIndex][currency_type_in]))
                status_code_reg = AMT_INVALID;
        end
        
        SELECT_CURRENCY_CONVERT_2: begin
        //
            if ((currency_type_in != currency_type_2_in) & (ready == 1'b1)) begin
                balance_database[accIndex][currency_type_in] = balance_database[accIndex][currency_type_in] - amount;
                balance_database[accIndex][currency_type_2_in] = balance_database[accIndex][currency_type_2_in] + (amount * conversion_database[currency_type_in][currency_type_2_in]);
                
            
            /*
                if (currency_type_second == USD) begin
                    balance_database[accIndex][currency_type] = balance_database[accIndex][currency_type] - amount;
                    balance_database[accIndex][currency_type_second] = balance_database[accIndex][currency_type_second] + (amount * conversion_database[currency_type][currency_type_second]); 
                end
                else if (currency_type_second == BTC) begin
                    balance_database[accIndex][currency_type] = balance_database[accIndex][currency_type] - amount;
                    balance_database[accIndex][currency_type_second] = balance_database[accIndex][currency_type_second] + (amount * conversion_database[currency_type][currency_type_second]); 
                end
                else if (currency_type_second == ETH) begin
                    balance_database[accIndex][currency_type] = balance_database[accIndex][currency_type] - amount;
                    balance_database[accIndex][currency_type_second] = balance_database[accIndex][currency_type_second] + (amount * conversion_database[currency_type][currency_type_second]); 
                end
                else if (currency_type_second == XRP) begin
                    balance_database[accIndex][currency_type] = balance_database[accIndex][currency_type] - amount;
                    balance_database[accIndex][currency_type_second] = balance_database[accIndex][currency_type_second] + (amount * conversion_database[currency_type][currency_type_second]); 
                end
                else if (currency_type_second == LTC) begin
                    balance_database[accIndex][currency_type] = balance_database[accIndex][currency_type] - amount;
                    balance_database[accIndex][currency_type_second] = balance_database[accIndex][currency_type_second] + (amount * conversion_database[currency_type][currency_type_second]); 
                end
                */
            end
            /*
            else if ((ready == 1'b1) & (amount > balance_database[accIndex][currency_type]))
                status_code_reg = AMT_INVALID;
            */
        end
        
        SELECT_AMOUNT_WITHDRAW: begin
            if ((ready == 1'b1) & (amount <= balance_database[accIndex][currency_type_in])) begin
                balance_database[accIndex][currency_type] = balance_database[accIndex][currency_type_in] - amount;
                //balance = balance_database[accIndex][currency_type];
                status_code_reg = AMT_VALID;
            end else if ((ready == 1'b1) & (amount > balance_database[accIndex][currency_type_in])) begin
                status_code_reg = AMT_INVALID;
            end
        end
        
        TRANSFER: begin
            if ((ready == 1'b1) & (wasFound == 1'b1)) begin
                status_code_reg = ACC_FOUND;
            end else if ((ready == 1'b1) & (wasFound == 1'b0)) begin
                status_code_reg = ACC_NOT_FOUND;
            end
        end
        
        SELECT_AMOUNT_TRANSFER: begin
            if ((ready == 1'b1) & (amount <= balance_database[accIndex][currency_type_in]) & (balance_database[accIndex][currency_type_in] + amount < 2048)) begin
                balance_database[destinationAccIndex][currency_type_in] = balance_database[destinationAccIndex][currency_type_in] + amount;
                balance_database[accIndex][currency_type_in] = balance_database[accIndex][currency_type_in] - amount;
                status_code_reg = AMT_VALID;
            end else if ((ready == 1'b1) & ((amount > balance_database[accIndex][currency_type_in]) | (balance_database[accIndex][currency_type_in] + amount > 2048))) begin
                status_code_reg = AMT_INVALID;
            end
        end
        
        ERROR: begin
        end
        
    endcase
    end
    
    assign status_code = status_code_reg;
    assign balance_dollars_out = balance_database[accIndex][USD];
    assign balance_btc_out = balance_database[accIndex][BTC];
    assign balance_eth_out = balance_database[accIndex][ETH];
    assign balance_xrp_out = balance_database[accIndex][XRP];
    assign balance_ltc_out = balance_database[accIndex][LTC];
    
endmodule
