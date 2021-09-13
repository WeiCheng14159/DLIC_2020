// This is generated automatically on 2021/09/13-15:29:00
// Check the # of bits for state registers !!!
// Check the # of bits for flag registers !!!

`ifndef __FLAG_DEF__
`define __FLAG_DEF__

// There're 6 states in this design
`define S_INIT                 	 0  
`define S_READ                 	 1  
`define S_ACCU                 	 2  
`define S_PROC                 	 3  
`define S_OUTP                 	 4  
`define S_END                  	 5  
`define S_ZVEC                 	 6'b0
`define STATE_W                	 6  

// Macro from template
`define BUF_SIZE               	 9  
`define EMPTY_ADDR             	 {12{1'b0}}
`define EMPTY_DATA             	 {20{1'b0}}
`define LOCAL_IDX_W            	 16 
`define DATAX_W                	 8  
`define DATAY_W                	 10 

// Self-defined macro
`define CNT_W                  	 4  

`endif
