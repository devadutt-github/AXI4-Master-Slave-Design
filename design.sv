// Code your design here
`timescale 1ns / 1ps


`include "axi4_lite_master.sv"
`include "axi4_lite_slave.sv"
`include "memory.sv"

module axi4_lite_top#(
parameter DATA_WIDTH = 32,
parameter ADDRESS = 32
)(
input                           ACLK,
input                           ARESETN,
input                           read_s,
input                           write_s,
input    [ADDRESS-1:0]          address,
input                           LAST_tb,
input    [DATA_WIDTH-1:0]       W_data,
output wire [DATA_WIDTH-1:0]       R_data
);

logic M_ARREADY,S_RVALID,M_ARVALID,M_RREADY,S_AWREADY,S_BVALID,M_AWVALID,M_BREADY,M_WVALID,S_WREADY, WLAST, RLAST;
logic [ADDRESS-1:0]M_ARADDR,M_AWADDR;
logic [DATA_WIDTH-1:0]M_WDATA,S_RDATA;
logic [3:0]M_WSTRB;
logic [1:0]S_RRESP,S_BRESP;

  logic [31:0] t_mem_ADDRESS, t_mem_DATA_out, t_mem_DATA_in, faddr;
logic t_mem_rw, t_mem_enable, en;



axi4_lite_master u_axi4_lite_master0
(
.ACLK(ACLK),
.ARESETN(ARESETN),
.START_READ(read_s),
.address(address),
.LAST(LAST_tb),
.W_data(W_data),
.M_ARREADY(M_ARREADY),
.M_RDATA(S_RDATA),
.M_RRESP(S_RRESP),
.M_RVALID(S_RVALID),
.M_ARADDR(M_ARADDR),
.M_ARVALID(M_ARVALID),
.M_RREADY(M_RREADY),
.START_WRITE(write_s),
.M_AWREADY(S_AWREADY),
.M_WVALID(M_WVALID),
.M_WREADY(S_WREADY),
.M_BRESP(S_BRESP),
.M_BVALID(S_BVALID),
.M_AWADDR(M_AWADDR),
.M_AWVALID(M_AWVALID),
.M_WDATA(M_WDATA),
.M_WSTRB(M_WSTRB),
.R_data(R_data),
.M_BREADY(M_BREADY)
);

axi4_lite_slave u_axi4_lite_slave0
(
.ACLK(ACLK),
.ARESETN(ARESETN),
.S_ARREADY(M_ARREADY),
.S_RDATA(S_RDATA),
.S_RRESP(S_RRESP),
.S_RVALID(S_RVALID),
.S_ARADDR(M_ARADDR),
.LAST(LAST_tb),
.S_ARVALID(M_ARVALID),
.S_RREADY(M_RREADY),
.S_AWREADY(S_AWREADY),
.S_WVALID(M_WVALID),
.S_WREADY(S_WREADY),
.S_BRESP(S_BRESP),
.S_BVALID(S_BVALID),
.S_AWADDR(M_AWADDR),
.S_AWVALID(M_AWVALID),
.S_WDATA(M_WDATA),
.S_WSTRB(M_WSTRB),
.S_BREADY(M_BREADY),

.mem_enable(t_mem_enable),
.mem_rw(t_mem_rw),
.mem_ADDRESS(t_mem_ADDRESS),
.mem_DATA_out(t_mem_DATA_out),
  .mem_DATA_in(t_mem_DATA_in)

);

 memory u_memory0(
    .clk(ACLK),
    .enable(t_mem_enable),
    .rw(t_mem_rw),
    .address(t_mem_ADDRESS),
    .data_in(t_mem_DATA_in),
   
   
    .data_out(t_mem_DATA_out)
);
 
endmodule