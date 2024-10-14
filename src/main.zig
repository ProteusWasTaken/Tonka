const std = @import("std");

const BLACK = "\x1b[0;90m";
const RED = "\x1b[0;91m";
const GREEN = "\x1b[0;92m";
const YELLOW = "\x1b[0;93m";
const BLUE = "\x1b[0;94m";
const MAGENTA = "\x1b[0;95m";
const CYAN = "\x1b[0;96m";
const WHITE = "\x1b[0;97m";
const RESET = "\x1b[0m";

// Functions
fn printColor(colorCode: []const u8, inputString: []const u8) void {
    const stdout = std.io.getStdOut().writer();
    stdout.print("{s}{s}{s}", .{ colorCode, inputString, RESET }) catch unreachable;
}
fn printHelp() void {}
fn valorant() void {}
fn minecraft() void {}
fn fortnite() void {}
fn chess() void {}

// Variables
const gamesList = [_][]const u8{ "valorant", "val", "fn", "fortnite", "mc", "minecraft", "chess" };
const numberOfGames = @countOf(gamesList);

pub fn main() void {
    const args = std.os.argv();
    const argc = args.len;

    if (argc < 2) {
        printColor(RED, "Please provide a game to play using --<game>!\n");
        return;
    }

    const userInput = args[1];

    if (std.mem.eql(u8, userInput, "--help")) {
        printHelp();
        return;
    }

    if (!std.mem.startsWith(u8, userInput, "--")) {
        printColor(RED, "Invalid format. Please use --help\n");
        return;
    }

    const userGame = userInput[2..]; // Skip the '--'
    var gameFound = false;

    for (game in gamesList) {
        if (std.mem.eql(u8, userGame, game)) {
            gameFound = true;
            break;
        }
    }

    if (gameFound) {
        std.debug.print("Running the function for: {}\n", .{userGame});
        if (std.mem.eql(u8, userGame, "minecraft") or std.mem.eql(u8, userGame, "mc")) {
            minecraft();
        } else if (std.mem.eql(u8, userGame, "fortnite") or std.mem.eql(u8, userGame, "fn")) {
            fortnite();
        } else if (std.mem.eql(u8, userGame, "valorant") or std.mem.eql(u8, userGame, "val")) {
            valorant();
        } else if (std.mem.eql(u8, userGame, "chess")) {
            chess();
        }
    } else {
        std.debug.print("Game '{}' not recognized. Available games are:\n", .{userGame});
            for (game in gamesList) {
            std.debug.print("# {}\n", .{game}) catch {};
        }
    }
}
