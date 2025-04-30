
module testbench;
    reg clk = 0;
    reg pclk = 0;
    reg vsync = 0;
    reg href = 0;
    reg [7:0] cam_data = 0;
    wire [63:0] compressed_output;
    wire output_valid;

    always #5 clk = ~clk;      // System clock = 100 MHz
    always #10 pclk = ~pclk;   // Pixel clock = 50 MHz

    camera_system_top uut (
        .clk(clk),
        .pclk(pclk),
        .vsync(vsync),
        .href(href),
        .cam_data(cam_data),
        .compressed_output(compressed_output),
        .output_valid(output_valid)
    );

    integer frame, pixel;

    initial begin
        for (frame = 0; frame < 4; frame = frame + 1) begin  // 3 frames
            $display("Starting Frame %0d", frame + 1);
            vsync = 1; #100; vsync = 0;

            for (pixel = 0; pixel < 640*480; pixel = pixel + 1) begin
                href = 1;
                cam_data = $random;
                #20;  // one pixel every 20 time units
            end
            href = 0;

            // Wait time between frames to allow compression
            #100000;  // increase if needed
            //#620000000;
        end

        $finish;
    end
endmodule
