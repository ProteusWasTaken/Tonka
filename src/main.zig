const std = @import("std");

pub fn main() void {}

const Color = struct {
    const BLACK = "\x1b[0;90m";
    const RED = "\x1b[0;91m";
    const GREEN = "\x1b[0;92m";
    const YELLOW = "\x1b[0;93m";
    const BLUE = "\x1b[0;94m";
    const MAGENTA = "\x1b[0;95m";
    const CYAN = "\x1b[0;96m";
    const WHITE = "\x1b[0;97m";
    const RESET = "\x1b[0m";
};

fn printColor(colorCode: []const u8, inputString: []const u8) void {
    const stdout = std.io.getStdOut().writer();
    stdout.print("{s}{s}{s}", .{ colorCode, inputString, Color.RESET }) catch unreachable;
}

fn getUserInput() u8 {
    const stdin = std.io.getStdIn().reader();
    const emptyLine = stdin.readUntilDelimiterAlloc(
        std.heap.page_allocator,
        '\n',
        8192,
    ) catch return 0;
    defer std.heap.page_allocator.free(emptyLine);
    const line = std.mem.trim(u8, emptyLine, "\r");

    const usersInput = std.fmt.parseInt(u8, line, 10) catch {
        printColor(Color.red, "Please enter a valid number.\n");
        return 0;
    };
    return usersInput;
}

const games = struct {
    const list = [_][]const u8{ "val", "valorant", "fn", "fortnite", "mc", "minecraft", "chess" };

    fn printHelp() void {}

    fn valorant() void {}

    fn minecraft() void {}

    fn fortnite() void {
        const elims: u8 = getUserInput();
        const deathKnock: u8 = getUserInput();
        const assists: u8 = getUserInput();

        const total: i16 = 10 + (3 * deathKnock) - (2 * elims) - (assists / 2);

        printColor(Color.GREEN, "Total Reps: ");
        std.debug.print("{}\n", .{total});
    }

    fn chess() void {
        const piecesTaken: u8 = getUserInput();
        const piecesStolen: u8 = getUserInput();
        const winOrLose: u8 = getUserInput();

        const total: i16 = 10 + (3 * piecesStolen) - (2 * piecesTaken) - (winOrLose / 2);

        printColor(Color.GREEN, "Total Reps: ");
        std.debug.print("{}\n", .{total});
    }
};
