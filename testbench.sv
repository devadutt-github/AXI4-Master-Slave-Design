`timescale 1ns / 1ps
//`include "axi4_lite_top.v"


module axi4_lite_tb();

    logic           ACLK_tb;
    logic           ARESETN_tb;
    logic           read_s_tb;
    logic           write_s_tb;
  	logic           last_tb;
    logic [31:0]    address_tb;
    logic [31:0]    W_data_tb;
  	logic [31:0]    R_data_tb;
    
    axi4_lite_top u_axi4_lite_top0(
        .ACLK(ACLK_tb),
        .ARESETN(ARESETN_tb),
        .read_s(read_s_tb),
        .write_s(write_s_tb),
        .LAST_tb(last_tb),
        .address(address_tb),
        .R_data(R_data_tb),
        .W_data(W_data_tb)
    );

    initial begin
               #5;
               ACLK_tb=0;
               ARESETN_tb=0;
               read_s_tb=0;  
               write_s_tb=0;                           
               #5;
               ACLK_tb=1;
               ARESETN_tb=1;
               write_s_tb=0;
      		   last_tb = 0;
               #15;
               write_s_tb=1;
               #30; // for state change
               address_tb = 5'd19;
               W_data_tb = 32'hFFFF_0000;
               #10
               W_data_tb = 32'hFFFF_0001;
      		   #10;
               W_data_tb = 32'hFFFF_0002;
             #10;
               W_data_tb = 32'hFFFF_0003;
             #10;
            W_data_tb = 32'hFFFF_0004;
            #10;
            W_data_tb = 32'hFFFF_0005;
            #10;
            W_data_tb = 32'hFFFF_0006;
            #10;
            W_data_tb = 32'hFFFF_0007;
            #10;
            W_data_tb = 32'hFFFF_0008;
          last_tb = 1;
          #10;  
            W_data_tb = 0;
            write_s_tb=0;
            last_tb = 0;
            #20;
            write_s_tb=0;
            read_s_tb=0;
          last_tb = 0;
            #30;
            read_s_tb=1;
            address_tb = 5'd19;
            last_tb = 0;
            #30; // for state changes
            #150; // for 5 read cycles (30 * 3)
        last_tb = 1;
            read_s_tb=0;
          #20;
            write_s_tb=0;
            read_s_tb=0;
          last_tb = 0;
            #20;
            write_s_tb=1;
            #30; // for state change
            address_tb = 31;
            W_data_tb = 32'hFFFF_FFFF;
            last_tb = 1;
            #10
          W_data_tb = 0;
            write_s_tb=0;
            last_tb = 0;
            #20;
            read_s_tb=1;
            address_tb = 31;
            last_tb = 0;
            #30; // for state changes
            #30; // for 1 read cycles (30 * 1)
        last_tb = 1;
            read_s_tb=0;
          #20;
            write_s_tb=0;
            read_s_tb=0;
          last_tb = 0;
            #20;
  
            #40;
            $finish;            
end

always begin
#5 ACLK_tb = ~ACLK_tb;
end

initial begin
    $dumpfile("axi4_lite_top_tb.vcd");
    $dumpvars(0, axi4_lite_tb);
end
  
endmodule