`include "def.v"

module CS(
  input                                 clk, 
  input                                 reset,
  input                           [7:0] X,
  output                          [9:0] Y
);

  reg                      [`CNT_W-1:0] cnt;
  reg                    [`DATAX_W-1:0] buffer [`BUF_SIZE-1:0];
  reg                    [`DATAY_W-1:0] Y_r;

// FSM state register
reg [1:0] curr_state, next_state;
// FSM state declaration
parameter [1:0] S_READ = 2'b01, S_OUTP = 2'b10;

// State register (S)
always @(posedge clk, posedge reset) begin
  if (reset)
    curr_state <= S_READ;
  else
    curr_state <= next_state;
end

//  Counter increment
always @(posedge clk) begin
    if (reset)
      cnt <= 0;
    else if (cnt == 9)
      cnt <= 9;
    else
      cnt <= cnt + 1;
end

// Next state logic (Comb)
always @(*) begin
    case(curr_state)
        S_READ: begin
          next_state = (cnt != `BUF_SIZE-1) ? S_READ : S_OUTP;
        end
        S_OUTP:
          next_state = S_OUTP;
        default:
          next_state = S_READ;
    endcase
end

// Buffer index
reg [3:0] itrIdx, approxIdx;
// xAppr is the largest element in buffer that's smaller than xAvg
// diff is a temporary variable that keeps track of the difference between buffer[i] and xAvg
reg [8:0] xAppr, diff;
// sum is the sum of all elements in buffer
wire [40:0] sum = buffer[0] + buffer[1] + buffer[2] + buffer[3] + buffer[4] + buffer[5] + buffer[6] + buffer[7] + buffer[8];
// sum / 9
wire [8:0] xAvg = (sum * 32'h1C71C71D) >> 32;

// Output logic (Comb)
always @(*) begin
    diff = 9'h0FF;
    xAppr = 9'h000;
    approxIdx = 0;
    case(curr_state)
        S_READ:
            ;
        S_OUTP: begin
            // Find xAppr in buffer
            for(itrIdx = 0 ; itrIdx <= 8 ; itrIdx = itrIdx + 1)
                if ((xAvg - buffer[itrIdx] < diff) & (xAvg > buffer[itrIdx])) begin
                    approxIdx = itrIdx;
                    diff = xAvg - buffer[itrIdx];
                end
                else if (xAvg == buffer[itrIdx]) begin
                    approxIdx = itrIdx;
                    diff = 0;
                end
            xAppr = buffer[approxIdx];
        end
        default: ;
    endcase
end

// Write to Y
wire nclk = ~clk;
always @(posedge nclk, posedge reset) begin
  if(reset)
    Y_r <= 0;
  else if(cnt == 9)
    Y_r <= ((xAppr << 3) + xAppr + sum) >> 3;
end
assign Y = Y_r;

integer i;
always @(posedge clk, posedge reset) begin
  if (reset) begin
      for(i=0 ; i<`BUF_SIZE; i=i+1)
          buffer[i] <= 0;
  end else begin
      for(i=0 ; i<`BUF_SIZE-1 ; i=i+1) begin
          buffer[i] <= buffer[i+1];
      end
      buffer[8] <= X;
  end
end

endmodule
