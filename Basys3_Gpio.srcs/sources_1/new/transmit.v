`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/21/2021 12:57:02 AM
// Design Name: 
// Module Name: transmit
// Project Name: UART_on_FPGA
// Target Devices: Basys 3
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


module transmitter(clk, tx, data_in, ack, sent);

    input clk;
    output reg tx;
    input [7:0]data_in;
    input ack;
    output reg sent;
    
    reg [7:0]data;
    
    reg [1:0]state;
    reg [9:0]count;
    reg [3:0]bitcount;
    
    parameter CLK_RATE_PER_BIT = 868; //CLK_RATE / BAUD_RATE
    parameter IDLE = 2'b00;
    parameter START = 2'b01;
    parameter DATA = 2'b10;
    parameter STOP = 2'b11;
    
    always @(posedge clk) begin
        case(state)
            IDLE : begin
               data <= data_in;
               if(ack) begin
                    state <= START;
               end 
               else begin
                    state <= IDLE;
               end
               count <= 0;
               bitcount <= 0;
               tx <= 1;     
               sent <= 0;
            end
            START : begin
                if(count < CLK_RATE_PER_BIT) begin
                    count <= count + 1;
                    tx <= 0;
                    state <= START;
                end
                else begin
                    count <= 0;
                    tx <= 0;
                    state <= DATA; 
                end
                bitcount <= 0;
                sent <= 0;
            end
            DATA : begin
                if(bitcount < 4'b1000) begin
                    if(count < CLK_RATE_PER_BIT) begin
                        count <= count + 1;
                        tx <= data[bitcount];
                    end
                    else begin
                        count <= 0;
                        tx <= data[bitcount];
                        bitcount <= bitcount + 1;
                    end
                    state <= DATA;
                end
                else begin
                    tx <= data[7];
                    bitcount <= 0;
                    count <= 0;
                    state <= STOP;
                end
                sent <= 0;
            end
            STOP : begin
                if(count < CLK_RATE_PER_BIT) begin
                    count <= count + 1;
                    tx <= 1;
                    state <= STOP;
                    sent <= 0;
                end
                else begin
                    count <= 0;
                    tx <= 1;
                    state <= IDLE; 
                    sent <= 1;
                end
                bitcount <= 0;
            end
            default: begin
                state <= IDLE;
                data <= 0;
                count <= 0;
                bitcount <= 0;
                sent <= 0;
            end
        endcase
    end
endmodule