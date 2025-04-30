module compressor #(
    parameter FRAME_WIDTH = 640,
    parameter FRAME_HEIGHT = 480,
    parameter OUT_SIZE = 8,
    parameter THRESHOLD = 128
)(
    input wire clk,
    input wire start,
    output reg done,
    output reg [63:0] compressed_image,
    input wire [7:0] frame_data,
    output reg [18:0] frame_addr
);

    localparam BLOCK_W = FRAME_WIDTH / OUT_SIZE;
    localparam BLOCK_H = FRAME_HEIGHT / OUT_SIZE;

    reg [5:0] i, j;
    reg [2:0] state;

    always @(posedge clk) begin
        if (start) begin
            state <= 1;
            i <= 0;
            j <= 0;
            done <= 0;
            compressed_image <= 64'b0;
        end else begin
            case (state)
                1: begin
                    frame_addr <= (i * BLOCK_H * FRAME_WIDTH) + (j * BLOCK_W);
                    state <= 2;
                end
                2: begin
                    if (frame_data > THRESHOLD)
                        compressed_image[i * OUT_SIZE + j] <= 1;
                    else
                        compressed_image[i * OUT_SIZE + j] <= 0;
                    if (j == OUT_SIZE - 1) begin
                        j <= 0;
                        i <= i + 1;
                    end else begin
                        j <= j + 1;
                    end
                    if (i == OUT_SIZE && j == OUT_SIZE - 1) begin
                        done <= 1;
                        state <= 0;
                    end else begin
                        state <= 1;
                    end
                end
            endcase
        end
    end
endmodule
