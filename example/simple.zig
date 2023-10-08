const std = @import("std");
const cli = @import("zig-cli");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

var abc: u16 = undefined;
var abc2: []const u8 = undefined;
var abc3: []u16 = undefined;
var wr = cli.AllocWrapper{ .alloc = allocator };

var ip_option = cli.Option{
    .long_name = "ip",
    .help = "this is the IP address",
    .short_alias = 'i',
    .value = cli.OptionValue{ .string = null },
    .required = true,
    .value_name = "IP",
};
var int_option = cli.Option{
    .long_name = "int",
    .help = "this is an int",
    .value = cli.OptionValue{ .int = null },
    .value_ref = cli.valueRef(&abc),
    // .value_ref2 = wr.sigleInt(&abc),
};
var bool_option = cli.Option{
    .long_name = "bool",
    .short_alias = 'b',
    .help = "this is a bool",
    .value = cli.OptionValue{ .bool = false },
};
var float_option = cli.Option{
    .long_name = "float",
    .help = "this is a float",
    .value = cli.OptionValue{ .float = 0.34 },
};

var name_option = cli.Option{
    .long_name = "long_name",
    .help = "long_name help",
    .value = cli.OptionValue{ .string = null },
};
var app = &cli.App{
    .name = "simple",
    .description = "This a simple CLI app\nEnjoy!",
    .version = "0.10.3",
    .author = "sam701 & contributors",
    .subcommands = &.{&cli.Command{
        .name = "sub1",
        .help = "another awesome command",
        .description =
        \\this is my awesome multiline description.
        \\This is already line 2.
        \\And this is line 3.
        ,
        .options = &.{
            &ip_option,
            &int_option,
            &bool_option,
            &float_option,
        },
        .subcommands = &.{
            &cli.Command{
                .name = "sub2",
                .help = "sub2 help",
                .action = run_sub2,
            },
        },
    }},
};

pub fn main() anyerror!void {
    // this works
    // var a: u16 = 3;
    // var p = cli.IntParser(u16);
    // var t = cli.singleValueRef(u16, &a, p, allocator);
    // try t.put("56");
    // std.debug.print("a = {}\n", .{a});

    // var ov = int_option.value_ref.?;
    // std.log.info("hello", .{});
    // try ov.set("44");
    // std.log.debug("value: {}\n", .{abc});

    // var ov = int_option;
    // _ = ov;
    // try ov.put("45");
    var ov = try wr.singleInt(&abc);
    try ov.put("173");
    std.log.debug("value: {}\n", .{abc});

    var a = try wr.string(&abc2);
    try a.put("hello");
    std.log.debug("value: {s}\n", .{abc2});

    var a2 = try wr.multiInt(&abc3);
    try a2.put("5");
    try a2.put("10");
    try a2.finalize();
    std.log.debug("value: {any}\n", .{abc3});

    return cli.run(app, allocator);
}

fn run_sub2(args: []const []const u8) anyerror!void {
    var ip = ip_option.value.string.?;
    std.log.debug("running sub2: ip={s}, bool={any}, float={any} arg_count={any}", .{ ip, bool_option.value.bool, float_option.value.float, args.len });
}
