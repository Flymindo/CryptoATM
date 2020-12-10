`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2020 11:36:48 AM
// Design Name: 
// Module Name: asciitobinary
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
/////////////////////////////////////////////////////////////////////////////////
// used after ascii_decoder.v/within user_input.v

module asciitobinary (in,out,clk, count,current_state, status_code_in);
input [7:0] in; 	//ASCII input
input clk;		//Clock Signal	
input [3:0] count;
input [15:0] current_state;
input status_code_in;  //This bit goes to 1 if the data byte is received properly

output reg [3:0] out;	//Binary Output, digits 0-9 only

//parameter s0 = 2'b00, s1 = 2'b01, s2 = 2'b10, s3 = 2'b11;  //defining different states for Finite State Machine
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
reg fsm;		//FSM output					   
reg [3:0] a;
reg [15:0] state;	//Variable for tracking the state


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
	
always @ (posedge clk)begin
	if (in == 8'h71)begin // q for QUIT/RESET
		state = IDLE; out = 0; a =0 ;	
	end
	else begin                     //Finite State Machine: Mealy Machine
	case (current_state)
		IDLE: begin
			fsm =0; 
			if (count !== 0) begin
				ascii2binary(in,a);
				out <= a;
				//$display ($realtime, "ns %d", out);
 			end
 			/*
			else if(status_code_in !== INPUT_COMPLETE)
				state = IDLE;
			end
			*/
		end
		PIN_INPUT: begin
			fsm =0; 
			if (count !== 0) begin
				ascii2binary(in,a);
				out <= a;
				//$display ($realtime, "ns %d", out);
 			end
 			/*
			else if (status_code_in !== INPUT_COMPLETE) begin
				state = PIN_INPUT;
			end
			*/
		end/*
		MENU: begin
			fsm =1;
			if (in == 0) begin
				$display ($realtime, "ns %d", out);
				state = s0;
 			end
			else begin
				state = s3;
			end 
			*/
		//end
	endcase
	end
end
endmodule	