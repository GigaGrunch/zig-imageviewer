const debug = @import("std").debug;

pub fn main() void
{
    debug.warn("Hello {}!\n", .{"World"});
}
