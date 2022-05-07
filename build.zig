const Builder = @import("std").build.Builder;

pub fn build(builder: *Builder) void
{
    const exe = builder.addExecutable("imageviewer", "code/main.zig");
    exe.addIncludeDir("SDL2/include");
    exe.addObjectFile("SDL2/lib/SDL2.lib");
    exe.linkLibC();
    exe.install();

    builder.installBinFile("SDL2/lib/SDL2.dll", "SDL2.dll");

    const run_command = exe.run();
    run_command.addPathDir("SDL2/lib");
    if (builder.args) |args| {
        run_command.addArgs(args);
    }

    const run_step = builder.step("run", "Run the app");
    run_step.dependOn(&run_command.step);
}