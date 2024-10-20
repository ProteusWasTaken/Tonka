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

    if (std.mem.eql(u8, args[1], "--test") or std.mem.eql(u8, args[1], "-t")) {
        games.valorant();
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
            printColor(Color.RED, "Please enter a valid number.\n");
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
        tools.printColor(Color.MAGENTA, "    tonka [FLAGS]\n");
        tools.printColor(Color.RESET, "\n");
        tools.printColor(Color.GREEN, "FLAGS:\n");
        tools.printColor(Color.MAGENTA, "    -h, --help                            Prints help information.\n");
        tools.printColor(Color.MAGENTA, "    -v, --version                         Shows Tonka version.\n");
        tools.printColor(Color.MAGENTA, "    -g, --games                           List suppourted games.\n");
        tools.printColor(Color.MAGENTA, "    -e, --exercises                       Returns a random exercise.\n");
        tools.printColor(Color.MAGENTA, "    -r, --random                    Returns a random exercise.\n");
        tools.printColor(Color.MAGENTA, "    -c {gameName}, --calc {gameName}      Prompts for passed game.\n");
        tools.printColor(Color.RESET, "\n");
    }

    fn tonkaArt() void {
        tools.printColor(Color.CYAN, " ____ ____ ____ ____ ____ \n");
        tools.printColor(Color.CYAN, "||T |||o |||n |||k |||a ||\n");
        tools.printColor(Color.CYAN, "||__|||__|||__|||__|||__||\n");
        tools.printColor(Color.CYAN, "|/__\\|/__\\|/__\\|/__\\|/__\\|\n");
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

    // Need a better formula this was just a thrown together one
    fn coding() void {
        tools.printColor(Color.GREEN, "Enter how long you spent coding in hours: ");
        const timeSpentHours: i8 = tools.getUserInput();
        tools.printColor(Color.GREEN, "Enter how many lines of code you altered: ");
        const linesOfCodeChanged: i8 = tools.getUserInput();

        const total = (timeSpentHours * 25) - (linesOfCodeChanged / 4);

        tools.printColor(Color.GREEN, "Total Reps: ");
        std.debug.print("{}\n", .{total});
    }

    fn valorant() void {
        tools.printColor(Color.GREEN, "Enter rounds won: ");
        const roundsWon: i16 = tools.getUserInput();
        tools.printColor(Color.GREEN, "Enter rounds lossed: ");
        const roundsLoss: i16 = tools.getUserInput();
        tools.printColor(Color.GREEN, "Enter your total kills: ");
        const kills: i16 = tools.getUserInput();
        tools.printColor(Color.GREEN, "Enter your total deaths: ");
        const deaths: i16 = tools.getUserInput();
        tools.printColor(Color.GREEN, "Enter your total assists: ");
        const assists: i16 = tools.getUserInput();

        const total: i16 = 2 * (5 + (2 * deaths) - (kills) - (@divTrunc(assists, 2)) - (@divTrunc(roundsWon, 2)) + (@divTrunc(roundsLoss, 2)));

        tools.printColor(Color.GREEN, "Total Reps: ");
        std.debug.print("{}\n", .{total});
    }

    fn minecraft() void {
        tools.printColor(Color.GREEN, "Enter deaths during session: ");
        const deaths: u8 = tools.getUserInput();
        tools.printColor(Color.GREEN, "Enter hours played for the session: ");
        const timePlayedHours: u8 = tools.getUserInput();
        tools.printColor(Color.GREEN, "Enter total XP: ");
        const levelsXP: u8 = tools.getUserInput();

        const total = 10 + (3 * deaths) - (2 * timePlayedHours) - (levelsXP / 2);

        tools.printColor(Color.GREEN, "Total Reps: ");
        std.debug.print("{}\n", .{total});
    }

    fn fortnite() void {
        tools.printColor(Color.GREEN, "Enter total eliminations: ");
        const elims: u8 = tools.getUserInput();
        tools.printColor(Color.GREEN, "Enter total knockdowns and/or deaths: ");
        const deathKnock: u8 = tools.getUserInput();
        tools.printColor(Color.GREEN, "Enter total assists: ");
        const assists: u8 = tools.getUserInput();

        const total: i16 = 10 + (3 * deathKnock) - (2 * elims) - (assists / 2);

        tools.printColor(Color.GREEN, "Total Reps: ");
        std.debug.print("{}\n", .{total});
    }

    fn chess() void {
        tools.printColor(Color.YELLOW, "WIP");
        tools.printColor(Color.GREEN, "Enter total pieces you took: ");
        const piecesTaken: u8 = tools.getUserInput();
        tools.printColor(Color.GREEN, "Enter total pieces you had taken: ");
        const piecesStolen: u8 = tools.getUserInput();
        tools.printColor(Color.GREEN, "Are ya winning son?");
        const winOrLose: u8 = tools.getUserInput();

        const total: i16 = 10 + (3 * piecesStolen) - (2 * piecesTaken) - (winOrLose / 2);

        tools.printColor(Color.GREEN, "Total Reps: ");
        std.debug.print("{}\n", .{total});
    }
};
