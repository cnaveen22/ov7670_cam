module camera_system_top (
    input wire clk,
    input wire pclk,
    input wire vsync,
    input wire href,
    input wire [7:0] cam_data,
    output wire [63:0] compressed_output,
    output wire output_valid
);
    wire [18:0] addr;
    wire [7:0] pixel_data;
    wire we;
    wire [7:0] fb_data;

    reg start_compression;
    wire done;
    wire [18:0] frame_addr;

    camera_interface cam_if (
        .pclk(pclk),
        .vsync(vsync),
        .href(href),
        .cam_data(cam_data),
        .addr(addr),
        .pixel_data(pixel_data),
        .we(we)
    );

    frame_buffer fb (
        .clk(clk),
        .we(we),
        .addr(we ? addr : frame_addr),
        .din(pixel_data),
        .dout(fb_data)
    );

    compressor comp (
        .clk(clk),
        .start(start_compression),
        .done(done),
        .compressed_image(compressed_output),
        .frame_data(fb_data),
        .frame_addr(frame_addr)
    );

    assign output_valid = done;

    // Start compression once frame is captured (vsync falling edge detect)
    reg vsync_d;
    always @(posedge clk) begin
        vsync_d <= vsync;
        if (vsync_d && !vsync) begin
            start_compression <= 1;
        end else begin
            start_compression <= 0;
        end
    end
endmodule
