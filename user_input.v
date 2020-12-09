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
// asciitobinary.v calls are embedded


module user_input(
    input clk,
    input  [7:0] ascii_code,
    input  [3:0] input_style_out,
    input [15:0] current_state,
  output ready,
    output [3:0] status_code_out,
    output [15:0] pswd,
    output [15:0] acct,
    output [1:0] usr_input_out,
    output [2:0] currency_type_out,
    output [2:0] currency_type_2_out,
    output [15:0] destinationAcc
    );
  reg[3:0] a=0;
  reg [15:0] tpswd;
  reg [15:0] tacct;
  
  reg[3:0] status_codes;
  reg[1:0] usr_inputs;
  reg[2:0] currency_type;
  reg[2:0] currency_type_2;
  reg[15:0] destinationa;
    
  reg ready_reg;
  	//reg done=0;

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
    
    reg [2:0] count =0;
    
    /*
    `define CLOCK_FREQ 100000000 // 100 MHz clk
    `define TIME_DELAY 3 // seconds
    reg [31:0] timer = 0;
    */
    //assign do_something = (timer==`CLOCK_FREQ*`TIME_DELAY); //3 second pause
  
   task ascii2binary;
	input [7:0] digits_byte;  
	output [3:0]out;	
	begin
		case (digits_byte)
		8'h30: out = 4'b0000;		//ASCII hex 30 = 0 in Binary
		8'h31: out = 4'b0001;		//ASCII hex 31 = 1 in Binary
		8'h32: out = 4'b0010;		//ASCII hex 32 = 2 in Binary
		8'h33: out = 4'b0011;		//ASCII hex 33 = 3 in Binary
		8'h34: out = 4'b0100;		//ASCII hex 34 = 4 in Binary
		8'h35: out = 4'b0101; 		//ASCII hex 35 = 5 in Binary
		8'h36: out = 4'b0110;		//ASCII hex 36 = 6 in Binary
		8'h37: out = 4'b0111;		//ASCII hex 37 = 7 in Binary
		8'h38: out = 4'b1000;		//ASCII hex 38 = 8 in Binary
		8'h39: out = 4'b1001;		//ASCII hex 39 = 9 in Binary
		endcase
	end
   endtask
    
    always @(posedge clk) begin
    
    case(ascii_code)
        8'h71: begin   // q
            status_codes = EXIT;
            end
    endcase

    
    
    case(input_style_out)
        ACC_NUMBER: begin
        //done<=0;
          //if (ascii_code != 8'h2A) begin
            //Concatenation code for ACC_NUMBER  
            if(count == 3'b000 && status_codes != INPUT_COMPLETE) begin
                //a <= 4'b0000;
                //acct <= 16'b000000000000000;
                count <= count+1'b1;
              ascii2binary(ascii_code[7:0],a[3:0]); 
              tacct[3:0] <= a[3:0]; // 0 is the pin's LSB
              //done <= 1;
            end
            else if(count == 3'b001) begin
                //a <= 8'b00000000;
                count <= count+1'b1;
              ascii2binary(ascii_code[7:0],a);
              tacct[7:4] <= a[3:0];
              //done <= 1;
            end
            else if(count == 3'b010) begin
                //a3 <= 12'b000000000000;
                count <= count+1'b1;
                ascii2binary(ascii_code[7:0],a);
              tacct[11:8] <= a[3:0];
             // ascii_code <= 8'h2A;
              //done <= 1;
            end
            else if(count == 3'b011) begin
                //a4 <= 16'b0000000000000000;
                count <= count+1'b1;
                ascii2binary(ascii_code[7:0],a);
              tacct[15:12] <= a[3:0];
              //ascii_code <= 8'h2A;
              //done <= 1;
            end
            else if(count >= 3'b100) begin    
                //acct <= 16'b000000000000000;             
                //always @(posedge clk) begin
                    // ready signal using enter key
                    if(ascii_code == 8'h0D)         // Enter button pressed
                        begin
                            status_codes = INPUT_COMPLETE;
                            ready_reg = 1'b1;
                            if (current_state == TRANSFER) begin
                                destinationa <= tacct;
                            end 
                                //acct <= a4;
                          //ascii_code <= 8'h2A;
                        end
                    //timer <= timer + 1'b1; // waits for 3 seconds       
                //end
                count <= 3'b000;
            end  
        end
        //end
        
        PIN_NUMBER: begin
          //done <= 0;
          if (ascii_code != 8'h2A) begin // if code is non-default
            if(count == 3'b000 && status_codes !== INPUT_COMPLETE) begin // digit1
                //a1 <= 4'b0000;
                //pswd <= 16'b000000000000000;
                count <= count+1'b1;
                ascii2binary(ascii_code[7:0],a);
              tpswd[3:0] <= a[3:0]; // fill the LSB of output   
              //ascii_code <= 8'h2A;
              //done <= 1;
            end
            else if(count == 3'b001) begin
                //a2 <= 8'b00000000;
                count <= count + 1'b1;
                ascii2binary(ascii_code[7:0],a);
              tpswd[7:4] <= a[3:0];
              //ascii_code <= 8'h2A;
              //done <= 1;
            end
            else if(count == 3'b010) begin
                //a3 <= 12'b000000000000;
                count <= count + 1'b1;
                ascii2binary(ascii_code[7:0],a);
              tpswd[11:8] <= a[3:0];
              //ascii_code <= 8'h2A;
              //done <= 1;
            end
            else if(count == 3'b011) begin
                //a3 <= 12'b000000000000;
                count <= count + 1'b1;
                ascii2binary(ascii_code[7:0],a);
              tpswd[15:12] <= a[3:0];
              //ascii_code <= 8'h2A;
              //done <= 1;
            end
            else if(count >= 3'b100) begin
                //pswd <= 16'b0000000000000000;
                //always @(posedge clk) begin
                    // ready signal using enter key
                    if(ascii_code == 8'h0D)         // Enter button pressed
                        begin
                            status_codes = INPUT_COMPLETE;
                            //pswd <= a4;
                          //ascii_code <= 8'h2A;
                        end
                    //timer <= timer + 1'b1; // waits for 3 seconds       
                //end
                count <= 3'b000;
            end
        end
        end
        
        
        
        MENU_SELECTION: begin
            case(ascii_code)
                8'h62: begin                               // b key (balance)
                    usr_inputs = BALANCE;
                    end
                8'h63: begin                               // c (convert currency)
                    usr_inputs = CONVERT;
                    end
                8'h77: begin                               // w (withdraw)
                    usr_inputs = WITHDRAW_OPTION;
                    end
                8'h74: begin                              // t (transfer)
                    usr_inputs = TRANSFER_OPTION;
                    end
            endcase
            //always @(posedge clk) begin
                   // timer <= timer + 1'b1; // waits for 3 seconds       
                    // ready signal using enter key
                    if(ascii_code == 8'h0D)         // Enter button pressed
                        begin
                            status_codes = INPUT_COMPLETE;
                            ready_reg = 1'b1;
                        end
            //end
        end 
  
        SINGLE_KEY: begin                         
                //always @(posedge clk) begin
                   // timer <= timer + 1'b1; // waits for 3 seconds       
                    // ready signal using enter key
                    if(ascii_code == 8'h0D)         // Enter button pressed
                        begin
                            status_codes = INPUT_COMPLETE;
                            ready_reg = 1'b1;
                        end
                //end            
        end
                
        CURRENCY_TYPE: begin            ///1 to 5 cases         ///  currency_type_out = ascii hex   ///ready signal
            case(ascii_code)
                8'h31: begin                            // 1 - USD
                    if (current_state == SELECT_CURRENCY_CONVERT_2)
                        currency_type_2 = USD;
                    else
                        currency_type = USD;
                    end
                    
                8'h32: begin                            // 2 - BTC
                    if (current_state == SELECT_CURRENCY_CONVERT_2)
                        currency_type_2 = BTC;
                    else
                        currency_type = BTC;
                    end
                8'h33: begin                           // 3 - ETH
                    if (current_state == SELECT_CURRENCY_CONVERT_2)
                        currency_type_2 = ETH;
                    else
                        currency_type = ETH;
                    end
                8'h34: begin                           // 4 - XRP
                    if (current_state == SELECT_CURRENCY_CONVERT_2)
                        currency_type_2 = XRP;
                    else
                        currency_type = XRP;
                    end
                8'h35: begin                           // 5 - LTC
                    if (current_state == SELECT_CURRENCY_CONVERT_2)
                        currency_type_2 = LTC;
                    else
                        currency_type = LTC;
                    end
            endcase
            //always @(posedge clk) begin
                    //timer <= timer + 1'b1; // waits for 3 seconds       
                    // ready signal using enter key
                    if(ascii_code == 8'h0D)         // Enter button pressed
                        begin
                            status_codes = INPUT_COMPLETE;
                            ready_reg = 1'b1;
                        end
                //end
        end
            
            
        CURRENCY_AMOUNT: begin       
        
              //// until max out 8 digits or they hit enter /////////////////////////////////
              
            //always @(posedge clk) begin
                    //timer <= timer + 1'b1; // waits for 3 seconds       
                    // ready signal using enter key
                    if(ascii_code == 8'h0D)         // Enter button pressed
                        begin
                            status_codes = INPUT_COMPLETE;
                            ready_reg = 1'b1;
                        end
                //end
        end

    endcase
    end
    
    assign ready = ready_reg;
  	assign acct = tacct;
  	assign pswd = tpswd;
  	assign status_code_out = status_codes;
  	assign usr_input_out = usr_inputs;
  	assign currency_type_out = currency_type;
  	assign currency_type_2_out = currency_type_2;
    assign destinationAcc = destinationa;
    
endmodule