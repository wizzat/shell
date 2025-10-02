shell
=====

Shell Utilities.


rg\_and: A ripgrep-based utility which finds the set of files that contain all arguments
rg\_not: A ripgrep-based utility which finds the set of files containing the first argument but not the remaining

add: Adds the numbers in a series of columns.  Mostly useful in vim selections.

checkpoints.sh: A series of shell functions which allow you to "tag" certain directories and return to them later.
    $ ck shell
    Checkpoint (shell) = /home/wizzat/work/shell

    $ ckck
    bounce               = /home/wizzat
    default              = /home/wizzat/work/fictional_company/my_current_project
    proj                 = /home/wizzat/work/fictional_company/my_current_project
    scripts              = /home/wizzat/work/fictional_company/ops/scripts
    shell                = /home/wizzat/work/shell

    $ cd && pwd
    /home/wizzat

    $ gock shell
    Currently in /home/wizzat/work/shell

    $ gock proj
    Checkpoint (bounce) = /home/wizzat/work/shell
    Currently in /home/wizzat/work/fictional_company/my_current_project

    $ delck proj
    $ ..to work
    Currently in /home/wizzat/work

cmptree: Compares two trees for diffs.  This is primarily useful in p4 merges.

find\_unused\_python.sh A shell script for finding unused python functions and dead code.

find\_up: Finds a file (such as pom.xml or .ck) in any directory up from you (terminating at /).  Example:
    $ find_up pom.xml
    /home/wizzat/work/fictional_company/my_current_project/pom.xml

find\_up\_dir: Finds the directory above you where a certain file exists (such as pom.xml or .ck)
    $ find_up_dir pom.xml
    /home/wizzat/work/fictional_company/my_current_project/


format\_sql\_block.pl: A utility script I use to format SQL in a certain way.  The biggest remaining todo is to detect and align on AS blocks.  It integrates into vim with:
    map ,fs :!~/bin/format_sql_block.pl<CR>

tableize.pl: A utility script which I use to tableize certain blocks of code.  It integrates into vim with:
    map ,wt :perldo s/\s+$//g<CR>:perldo s/\t/    /g<CR>
    map ,a  :!~/work/shell/tableize.pl<CR>,wt<CR>



See perl_modules for list of perl modules which will need installing.

cdots.sh: A shell utility that I use heavily.  It has its own license (GPL).

## Python Scripts

**pyprofstats.py**: Profile statistics utility for analyzing Python profiling data. Updated to modern Python 3 with proper error handling and type hints.

**wailing_tritespace.py**: Whitespace processing utility that removes trailing whitespace and converts tabs to spaces. Updated to modern Python 3 with proper error handling.

**shell_cmd.py**: Command execution utilities for running shell commands and searching with ack. Updated to modern Python 3 with comprehensive type hints and improved exception handling.

### Testing

All Python scripts now include comprehensive unit tests in the `tests/` directory. To run tests:

```bash
pip install -r requirements-dev.txt
python -m pytest tests/ -v
```

### Modernization Changes

All Python files have been updated to modern Python 3 standards:
- Updated shebangs to `#!/usr/bin/env python3`
- Added comprehensive type hints
- Improved error handling and documentation
- Fixed bugs and used modern Python idioms
- Added comprehensive unit test coverage

LICENSE: MIT, except for cdots.sh which has its own license.
