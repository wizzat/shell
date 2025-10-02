#!/usr/bin/env python3
"""
Profile statistics utility for analyzing Python profiling data.
"""
import sys
import pstats
from typing import Optional


def main() -> None:
    """Main function to process and display profiling statistics."""
    if len(sys.argv) != 3:
        print("Usage: pyprofstats.py <profile_file> <num_stats>", file=sys.stderr)
        sys.exit(1)

    profile_file = sys.argv[1]

    try:
        num_stats = int(sys.argv[2])
    except ValueError:
        print(f"Error: '{sys.argv[2]}' is not a valid number", file=sys.stderr)
        sys.exit(1)

    try:
        p = pstats.Stats(profile_file)
        p.sort_stats('cumulative').print_stats(num_stats)
    except FileNotFoundError:
        print(f"Error: Profile file '{profile_file}' not found", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Error processing profile file: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
