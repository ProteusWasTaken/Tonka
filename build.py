import os
import sys
import subprocess
import platform
import time
from colorama import init, Fore

# Initialize Colorama
init()


def get_path(path):
    """Determine the correct path separator based on the OS."""
    if platform.system() == "Windows":
        return path.replace('/', '\\')
    else:
        return path.replace('\\', '/')

def get_zig_version():
    """Get the installed Zig version."""
    try:
        result = subprocess.run(["zig", "version"], capture_output=True, text=True, check=True)
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        return f"Failed to get Zig version: {e}"

def display_system_info():
    """Display basic system information."""
    print(Fore.MAGENTA + "\n--- System Information ---")
    print(Fore.GREEN + f"OS: {platform.system()} {platform.release()}")
    print(Fore.GREEN + f"Platform: {platform.platform()}")
    print(Fore.CYAN+ f"Python Version: {platform.python_version()}")
    zig_version = get_zig_version()
    print(Fore.CYAN + f"Zig Version: {zig_version}")
    print(Fore.YELLOW + f"Processor: {platform.processor()}")
    print(Fore.YELLOW + f"CPU Architecture: {platform.architecture()[0]}")  # 32-bit or 64-bit
    print(Fore.MAGENTA + "---------------------------\n")

def display_build_options():
    """Display the build mode options."""
    print(Fore.MAGENTA + "Select a build mode:")
    print(Fore.CYAN + "1. ReleaseSafe - Builds with runtime safety and speed optimization.")
    print(Fore.CYAN + "2. ReleaseSmall - Builds with size optimization only.")
    print(Fore.CYAN + "3. ReleaseFast - Builds with speed optimization only.")
    print(Fore.YELLOW + "Enter the number corresponding to your choice (1-3):")

def get_user_choice():
    """Get the user's choice for build mode."""
    while True:
        choice = input(Fore.GREEN + "Your choice: ")
        if choice in ['1', '2', '3']:
            return choice
        else:
            print(Fore.RED + "Invalid choice. Please enter a number between 1 and 3.")

def main(build_mode):
    display_system_info()

    print(Fore.GREEN + "Building Zig project...")
    print(Fore.YELLOW + "This script will build with runtime safety and speed optimization.")
    print(Fore.YELLOW + f"Using optimization mode: {build_mode}")

    # Set the path to the Zig source file
    source_file = get_path("./src/main.zig")

    exeName = "fitnessGames.out"

    # Start the timer
    start_time = time.time()

    # Build the Zig executable with the specified optimization mode
    try:
        subprocess.run(["zig", "build-exe", source_file, "-O", build_mode, "-femit-bin", exeName], check=True)
        end_time = time.time()
        print(Fore.GREEN + f"Build completed in {end_time - start_time:.2f} seconds.")
    except subprocess.CalledProcessError as e:
        end_time = time.time()
        print(Fore.RED + f"Build failed: {e}", file=sys.stderr)
        print(Fore.YELLOW + f"Build duration: {end_time - start_time:.2f} seconds.")
        return

#    print(Fore.GREEN + "Project Tree:")
#    try:
#        subprocess.run(["tree"], check=True)
#    except subprocess.CalledProcessError as e:
#        print(Fore.RED + f"Failed to get Tree structure of project: {e}", file=sys.stderr)

    print(Fore.GREEN + "Current Tokei Stats:")
    try:
        subprocess.run(["tokei"], check=True)
    except subprocess.CalledProcessError as e:
        print(Fore.RED + f"Failed to get Tokei stats: {e}", file=sys.stderr)

    print(Fore.YELLOW + "Current GIT Status:")
    try:
        subprocess.run(["git", "status"], check=True)
    except subprocess.CalledProcessError as e:
        print(Fore.RED + f"Failed to get GIT status: {e}", file=sys.stderr)

if __name__ == "__main__":
    display_build_options()
    user_choice = get_user_choice()

    # Map user choices to build modes
    build_modes = {
        '1': "ReleaseSafe",
        '2': "ReleaseSmall",
        '3': "ReleaseFast",
    }

    selected_build_mode = build_modes[user_choice]
    main(selected_build_mode)

