const std = @import("std");

pub fn main() !void {
    const args = try std.process.argsAlloc(std.heap.page_allocator);
    defer std.process.argsFree(std.heap.page_allocator, args);

    if (args.len < 2) return error.ExpectedArgument;

    if (std.mem.eql(u8, args[1], "--help") or std.mem.eql(u8, args[1], "-h")) {
        commands.printHelp();
        return;
    }

    if (std.mem.eql(u8, args[1], "--version") or std.mem.eql(u8, args[1], "-v")) {
        commands.printVersion();
        return;
    }

    if (std.mem.eql(u8, args[1], "--games") or std.mem.eql(u8, args[1], "-g")) {
        commands.listGames();
        return;
    }

    if (std.mem.eql(u8, args[1], "--exercise") or std.mem.eql(u8, args[1], "-e")) {
        try commands.getRandomExercise();
        return;
    }
    if (std.mem.eql(u8, args[1], "--random") or std.mem.eql(u8, args[1], "-r")) {
        const random_value = try tools.randomNumberGenerator(0, 100);
        tools.printColor(Color.GREEN, "Your random number is: ");
        std.debug.print("{}\n", .{random_value});
        return;
    }
}

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

const tools = struct {
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

    fn randomNumberGenerator(min: u8, max: u8) !u8 {
        var prng: std.rand.DefaultPrng = undefined;
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        prng = std.rand.DefaultPrng.init(seed);
        return prng.random().intRangeAtMost(u8, min, max);
    }
};

const commands = struct {
    fn printHelp() void {
        tools.printColor(Color.YELLOW, "Tonka Version 0.1.0\n");
        tools.printColor(Color.YELLOW, "Made with Zig version 0.13.0\n");
        tools.printColor(Color.RESET, "\n");
        tools.printColor(Color.GREEN, "USAGE:\n");
        tools.printColor(Color.MAGENTA, "    tonka [FLAGS] [OPTIONS]\n");
        tools.printColor(Color.RESET, "\n");
        tools.printColor(Color.GREEN, "FLAGS:\n");
        tools.printColor(Color.MAGENTA, "    -h, --help                            Prints help information.\n");
        tools.printColor(Color.MAGENTA, "    -v, --version                         Shows Tonka version.\n");
        tools.printColor(Color.MAGENTA, "    -g, --games                           List suppourted games.\n");
        tools.printColor(Color.MAGENTA, "    -e, --exercises                       Returns a random exercise.\n");
        tools.printColor(Color.MAGENTA, "    -c {gameName}, --calc {gameName}      Prompts for passed game.\n");
        tools.printColor(Color.RESET, "\n");
    }

    fn tonkaArt() void {
        tools.printColor(Color.CYAN, "████████╗ ██████╗ ███╗   ██╗██╗  ██╗ █████╗\n");
        tools.printColor(Color.CYAN, "╚══██╔══╝██╔═══██╗████╗  ██║██║ ██╔╝██╔══██╗\n");
        tools.printColor(Color.CYAN, "   ██║   ██║   ██║██╔██╗ ██║█████╔╝ ███████║\n");
        tools.printColor(Color.CYAN, "   ██║   ██║   ██║██║╚██╗██║██╔═██╗ ██╔══██║\n");
        tools.printColor(Color.CYAN, "   ██║   ╚██████╔╝██║ ╚████║██║  ██╗██║  ██║\n");
        tools.printColor(Color.CYAN, "   ╚═╝    ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝\n");
    }

    fn printVersion() void {
        tonkaArt();
        tools.printColor(Color.YELLOW, "Tonka Version 0.1.0\n");
    }

    fn listGames() void {
        for (games.list) |game| {
            std.debug.print("{s}\n", .{game});
        }
    }

    fn getRandomExercise() !void {
        const exerciseArrayLength: u8 = exercises.list.len;
        const chosenExercise: u8 = try tools.randomNumberGenerator(0, exerciseArrayLength - 1);
        std.debug.print("Your exercise is: {s}\n", .{exercises.list[chosenExercise]});
    }
};

const exercises = struct {
    const list = [_][]const u8{ "Pushups", "Pullups", "Situps", "Plank", "Squats", "Curls", "Lunges", "Jumping Jacks" };
};

const games = struct {
    const list = [_][]const u8{ "val", "valorant", "fn", "fortnite", "mc", "minecraft", "chess" };

    fn coding() void {}

    fn valorant() void {
        const roundsWon: u8 = tools.getUserInput();
        const roundsLoss: u8 = tools.getUserInput();
        const kills: u8 = tools.getUserInput();
        const deaths: u8 = tools.getUserInput();
        const assists: u8 = tools.getUserInput();

        const total = 2 * (5 + (2 * deaths) - (1.5 * kills) - (assists / 1.5) -
            (roundsWon / 2) + roundsLoss / 2);

        tools.printColor(Color.GREEN, "Total Reps: ");
        std.debug.print("{}\n", .{total});
    }

    fn minecraft() void {
        const deaths: u8 = tools.getUserInput();
        const timePlayedHours: u8 = tools.getUserInput();
        const levelsXP: u8 = tools.getUserInput();

        const total = 10 + (3 * deaths) - (2 * timePlayedHours) - (levelsXP / 2);

        tools.printColor(Color.GREEN, "Total Reps: ");
        std.debug.print("{}\n", .{total});
    }

    fn fortnite() void {
        const elims: u8 = tools.getUserInput();
        const deathKnock: u8 = tools.getUserInput();
        const assists: u8 = tools.getUserInput();

        const total: i16 = 10 + (3 * deathKnock) - (2 * elims) - (assists / 2);

        tools.printColor(Color.GREEN, "Total Reps: ");
        std.debug.print("{}\n", .{total});
    }

    fn chess() void {
        const piecesTaken: u8 = tools.getUserInput();
        const piecesStolen: u8 = tools.getUserInput();
        const winOrLose: u8 = tools.getUserInput();

        const total: i16 = 10 + (3 * piecesStolen) - (2 * piecesTaken) - (winOrLose / 2);

        tools.printColor(Color.GREEN, "Total Reps: ");
        std.debug.print("{}\n", .{total});
    }
};
