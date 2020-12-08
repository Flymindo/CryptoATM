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
//////////////////////////////////////////////////////////////////////////////////

module asciitobinary (in,out,clk,rst,status_code_in);
input [7:0] in; 	//ASCII input
input clk;		//Clock Signal
input rst;		
input status_code_in;  //This bit goes to 1 if the data byte is received properly

output reg [7:0] out;	//Binary Output

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
reg [7:0] a;
reg [4:0] state;	//Variable for tracking the state


   task ascii2binary;
	input [7:0] w_RX_byte;  
	output [7:0]out;	
	begin
		case (w_RX_byte)
		48: out = 0;		//ASCII value 48 = 0 in Binary
		49: out = 1;		//ASCII value 49 = 1 in Binary
		50: out = 2;		//ASCII value 50 = 2 in Binary
		51: out = 3;		//ASCII value 51 = 3 in Binary
		52: out = 4;		//ASCII value 52 = 4 in Binary
		53: out = 5; 		//ASCII value 53 = 5 in Binary
		54: out = 6;		//ASCII value 54 = 6 in Binary
		55: out = 7;		//ASCII value 55 = 7 in Binary
		56: out = 8;		//ASCII value 56 = 8 in Binary
		57: out = 9;		//ASCII value 57 = 9 in Binary
		endcase
	end
   endtask
	
always @ (posedge clk)begin
	if (in == 8'h71)begin
		state = IDLE; out = 0; a =0 ;	
	end
	else begin                     //Finite State Machine: Mealy Machine
	case (state)
		IDLE: begin
			fsm =0; 
			if (status_code_in) begin
				state = ACC_NUM;
				ascii2binary(in,a);
				out = out +  a * 100;
				//$display ($realtime, "ns %d", out);
 			end
			else begin
				state = IDLE;
			end
		end
		ACC_NUM: begin
			fsm =0; 
			if (status_code_in) begin
				state = PIN_INPUT;
				ascii2binary(in,a);
				out = out + a * 10;
				//$display ($realtime, "ns %d", out);
 			end
			else begin
				state = ACC_NUM;
			end
		end
		PIN_INPUT: begin
			fsm =0; 
			if (status_code_in) begin
				state = MENU;
				ascii2binary(in,a);
				out = out + a * 1;
				//$display ($realtime, "ns %d", out);
 			end
			else begin
				state = PIN_INPUT;
			end
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