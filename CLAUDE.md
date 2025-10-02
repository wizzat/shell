# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a collection of shell utilities and command-line tools for developer productivity. The project contains a mix of shell scripts (bash), Python 3 utilities, and Perl scripts. Recent work has focused on modernizing Python scripts to Python 3 with type hints, error handling, and comprehensive test coverage.

## Testing and Development Commands

### Running Tests
```bash
# Install test dependencies
pip install -r requirements-dev.txt

# Run all tests with coverage
python -m pytest tests/ -v

# Run specific test file
python -m pytest tests/test_pyprofstats.py -v

# Type checking
mypy pyprofstats.py wailing_tritespace.py
```

### Test Configuration
- pytest configuration in `pytest.ini`
- Tests located in `tests/` directory
- Test files follow pattern: `test_*.py`
- Coverage reports enabled by default

## Architecture

### Python Utilities

All Python scripts follow modern Python 3 patterns:
- Shebangs: `#!/usr/bin/env python3`
- Type hints for all functions
- Comprehensive error handling
- Unit test coverage in `tests/`

**pyprofstats.py**: Analyzes Python profiling data using pstats. Takes profile file and number of stats to display.

**wailing_tritespace.py**: Stdin processor that converts tabs to 4 spaces and removes trailing whitespace. Handles BrokenPipeError and KeyboardInterrupt gracefully.

### Shell Utilities

**rg_and**: Set intersection tool - finds files containing ALL specified patterns using ripgrep. Uses `comm -12` for intersection.

**rg_not**: Set difference tool - finds files containing first pattern but NOT subsequent patterns. Uses `comm -23` for set difference.

Both rg_* utilities use ripgrep for fast file searching and comm for set operations on sorted file lists.

**checkpoints.sh**: Directory bookmarking system with commands:
- `ck <name>` - bookmark current directory
- `gock <name>` - go to bookmarked directory
- `delck <name>` - delete bookmark
- `ckck` - list all checkmarks

**cdots.sh**: Shell navigation utility (GPL licensed, separate from MIT license for rest of repo)

**find_up**: Searches up directory tree for specified file (e.g., pom.xml, .ck)

**find_up_dir**: Returns directory path where specified file exists

### Perl Scripts

**format_sql_block.pl**: SQL formatter (integrates with vim via `,fs` mapping)

**tableize.pl**: Code tableization utility (integrates with vim via `,a` mapping)

Dependencies in `perl_modules` file

## Git Workflow

- Main branch: `master`
- Current development on feature branches
- Standard git workflow (add, commit, push)
