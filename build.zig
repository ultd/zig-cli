const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const lib = b.addStaticLibrary("zigcli", "src/command.zig");
    lib.setBuildMode(mode);
    lib.install();

    const main_tests = b.addTest("src/command.zig");
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);

    // const example_step = b.step("examples", "Build examples");
    const example = b.addExecutable("example", "example/simple.zig");
    example.addPackagePath("cli", "src/command.zig");
    example.setBuildMode(mode);
    example.install();
    // example_step.dependOn(&example.step);

    b.default_step.dependOn(&example.step);
}
