const Builder = @import("std").build.Builder;

pub fn build(builder: *Builder) void
{
    const exe = builder.addExecutable("imageviewer", "code/main.zig");
    exe.linkSystemLibrary("SDL2");
    exe.linkLibC();
    exe.install();

    const run_command = exe.run();
    if (builder.args) |args| {
        run_command.addArgs(args);
    }

    const run_step = builder.step("run", "Run the app");
    run_step.dependOn(&run_command.step);
}