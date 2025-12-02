import os
import sys
import argparse
import requests
from pathlib import Path

try:
    from aocd import get_data
    from aocd.exceptions import AocdError
except ImportError:
    print("Error: 'advent-of-code-data' library not found.", file=sys.stderr)
    print("Please install it by running: pip install advent-of-code-data", file=sys.stderr)
    sys.exit(1)

def get_session_cookie():
    """
    Retrieves the session cookie from the standard aocd token file
    or falls back to the environment variable.
    """
    aocd_token_path = Path.home() / ".config" / "aocd" / "token"
    if aocd_token_path.exists():
        return aocd_token_path.read_text().strip()
    return os.environ.get("AOC_SESSION")

def main():
    parser = argparse.ArgumentParser(description="Download Advent of Code input and description.")
    parser.add_argument("year", type=int, help="The Advent of Code year.")
    parser.add_argument("day", type=int, help="The Advent of Code day.")
    args = parser.parse_args()

    year = args.year
    day = args.day
    day_padded = f"{day:02d}"

    # --- Directory Setup ---
    current_dir = Path(__file__).parent
    input_dir = current_dir / "input" / str(year)
    puzzles_dir = current_dir / "puzzles" / str(year)

    input_dir.mkdir(parents=True, exist_ok=True)
    puzzles_dir.mkdir(parents=True, exist_ok=True)

    input_file_path = input_dir / f"{day_padded}.txt"
    puzzle_file_path = puzzles_dir / f"{day_padded}.html"

    # --- Download Input using aocd ---
    if input_file_path.exists():
        print(f"Input file already exists: {input_file_path}")
    else:
        try:
            print(f"Downloading input for Year {year}, Day {day} using aocd...")
            data = get_data(day=day, year=year)
            input_file_path.write_text(data, encoding='utf-8')
            print(f"Successfully saved input to: {input_file_path}")
        except AocdError as e:
            print(f"Error downloading input via aocd: {e}", file=sys.stderr)
            print("This could be due to an invalid session cookie or a network issue.", file=sys.stderr)
            sys.exit(1)
        except Exception as e:
            print(f"An unexpected error occurred during input download: {e}", file=sys.stderr)
            sys.exit(1)

    # --- Download Puzzle Description using requests ---
    # This will always re-download the description to get Part 2 after Part 1 is solved.
    try:
        print(f"Downloading puzzle description for Year {year}, Day {day}...")
        session_cookie = get_session_cookie()
        
        if not session_cookie:
            print("Error: Could not find session cookie.", file=sys.stderr)
            print("Please create ~/.config/aocd/token or set the AOC_SESSION environment variable.", file=sys.stderr)
            sys.exit(1)

        headers = {"Cookie": f"session={session_cookie}"}
        puzzle_url = f"https://adventofcode.com/{year}/day/{day}"
        
        response = requests.get(puzzle_url, headers=headers)
        response.raise_for_status()  # Raise an exception for HTTP errors

        if "[Log In]" in response.text:
            print("Error: Failed to authenticate. Your session cookie may be invalid or expired.", file=sys.stderr)
            sys.exit(1)

        # Save raw HTML content
        puzzle_file_path.write_text(response.text, encoding='utf-8')
        print(f"Successfully saved puzzle description to: {puzzle_file_path}")

    except requests.exceptions.RequestException as e:
        print(f"Error downloading puzzle description: {e}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"An unexpected error occurred during description download: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
