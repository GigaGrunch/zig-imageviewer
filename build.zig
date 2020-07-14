const Builder = @import("std").build.Builder;

pub fn build(builder: *Builder) void
{
    const exe = builder.addExecutable("imageviewer", "code/main.zig");
    builder.installArtifact(exe);

    const run_command = exe.run();
    const run_step = builder.step("run", "Run the app");
    run_step.dependOn(&run_command.step);
}