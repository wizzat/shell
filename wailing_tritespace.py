#!/usr/bin/env python3
"""
Whitespace processing utility that removes trailing whitespace and converts tabs to spaces.
"""
import sys
import re
from typing import TextIO


def process_whitespace(input_stream: TextIO = sys.stdin) -> None:
    """
    Process whitespace in input stream by converting tabs to spaces and removing trailing whitespace.

    Args:
        input_stream: Input text stream to process (defaults to stdin)
    """
    pattern = re.compile(r"\s+$")

    try:
        for row in input_stream:
            # Convert tabs to 4 spaces
            row = row.replace("\t", "    ")
            # Remove trailing whitespace
            row = pattern.sub("", row)
            print(row)
    except KeyboardInterrupt:
        # Handle Ctrl+C gracefully
        pass
    except BrokenPipeError:
        # Handle broken pipe (e.g., when output is piped to head)
        pass


def main() -> None:
    """Main function."""
    process_whitespace()


if __name__ == "__main__":
    main()

