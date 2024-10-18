// Colors for text
#define BLACK "\033[0;90m"
#define RED "\033[0;91m"
#define GREEN "\033[0;92m"
#define YELLOW "\033[0;93m"
#define BLUE "\033[0;94m"
#define MAGENTA "\033[0;95m"
#define CYAN "\033[0;96m"
#define WHITE "\033[0;97m"
#define RESET "\033[0m"

#include <math.h>
#include <stdio.h>
#include <string.h>

// Function Declarations
void printColor(const char *colorCode, const char *string1);
void printHelp(void);
void valorant(void);
void minecraft(void);
void fortnite(void);
void chess(void);

// Variable Definitions
char games[25][10] = {"valorant", "val",       "fn",   "fortnite",
                      "mc",       "minecraft", "chess"};
int numberOfGames = 7;

// Main function
int main(int argc, char *argv[]) {
  if (argc < 2) {
    printColor(RED, "Please provide a game to play using --<game>!\n");
    return 1;
  }

  char *userInput = argv[1];

  if (strcmp(userInput, "--help") == 0) {
    printHelp();
    return 0;
  }

  if (strncmp(userInput, "--", 2) != 0) {
    printColor(RED, "Invalid format. Please use --help\n");
    return 1;
  }

  char *userGame = userInput + 2;
  int gameFound = 0;

  for (int i = 0; i < numberOfGames; i++) {
    if (strcmp(userGame, games[i]) == 0) {
      gameFound = 1;
      break;
    }
  }

  if (gameFound) {
    printf("Running the function for: %s\n", userGame);
    if (strcmp(userGame, "minecraft") == 0) {
      minecraft();
    } else if (strcmp(userGame, "mc") == 0) {
      minecraft();
    } else if (strcmp(userGame, "fortnite") == 0) {
      fortnite();
    } else if (strcmp(userGame, "fn") == 0) {
      fortnite();
    } else if (strcmp(userGame, "valorant") == 0) {
      valorant();
    } else if (strcmp(userGame, "val") == 0) {
      valorant();
    } else if (strcmp(userGame, "chess") == 0) {
      chess();
    }

  } else {
    printf("Game '%s' not recognized. Available games are:\n", userGame);
    for (int i = 0; i < numberOfGames; i++) {
      printf("# %s\n", games[i]);
    }
    return 1;
  }

  return 0;
}
// Functions
void printColor(const char *colorCode, const char *string1) {
  printf("%s%s%s", colorCode, string1, RESET);
  fflush(stdout);
}
void printHelp(void) {
  printColor(YELLOW, "Possible Commands:\n");
  printColor(YELLOW, "--help\n");
  printColor(YELLOW, "--<nameOfGame>\n");
  printColor(YELLOW, "Games:\n");
  printColor(YELLOW, " - Minecraft\n");
  printColor(YELLOW, " - Valorant\n");
  printColor(YELLOW, " - Fortnite\n");
  printColor(YELLOW, " - Chess\n");
}
void valorant(void) {
  int deaths, kills, assists, roundsWon, roundsLoss;
  double total;

  printColor(GREEN, "Enter the number of round won: ");
  scanf("%d", &roundsWon);

  printColor(RED, "Enter the number of losing rounds: ");
  scanf("%d", &roundsLoss);

  printColor(BLUE, "Enter the number of Kills: ");
  scanf("%d", &kills);

  printColor(RED, "Enter the number of Deaths: ");
  scanf("%d", &deaths);

  printColor(MAGENTA, "Enter the number of Assists: ");
  scanf("%d", &assists);

  total = 2 * (5 + (2 * deaths) - (1.5 * kills) - (assists / 1.5) -
               ((double)roundsWon / 2) + (double)roundsLoss / 2);

  printColor(GREEN, "Total Reps = ");
  printf("%s%f%s", YELLOW, ceil(total), RESET);
}
void minecraft(void) {
  int deaths, timePlayed, levelsXP, total;

  printColor(BLUE, "Enter the number of XP: ");
  scanf("%d", &levelsXP);

  printColor(RED, "Enter the number of Deaths: ");
  scanf("%d", &deaths);

  printColor(MAGENTA, "Enter the amount of time played in hours: ");
  scanf("%d", &timePlayed);

  total = 10 + (3 * deaths) - (2 * timePlayed) - (levelsXP / 2);

  printColor(GREEN, "Total Reps = ");
  printf("%s%d%s", YELLOW, total, RESET);
}
