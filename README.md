shell
=====

Shell Utilities.

ack\_and: An ack-grep based utility which finds the set of files that contain all arguments.  It could be rewritten to use egrep -r over ack-grep.  An example is in order:
    $ ack foobar -l
    /home/wizzat/project/file1
    /home/wizzat/project/file2
    /home/wizzat/project/file3

    $ ack foobaz -l
    /home/wizzat/project/file2
    /home/wizzat/project/file4
    /home/wizzat/project/file5

    $ ack_and foobar foobaz
    /home/wizzat/project/file2

ack\_not: An ack-grep based utility which finds the set of files containing the first argument but not the remaining.  It could be rewritten to use egrep -r over ack-grep.  An example:
    $ ack foobar -l
    /home/wizzat/project/file1
    /home/wizzat/project/file2
    /home/wizzat/project/file3

    $ ack correct_foobar_import -l
    /home/wizzat/project/file2
    /home/wizzat/project/file3
    /home/wizzat/project/file4

    $ ack_not foobar correct_foobar_import
    /home/wizzat/project/file1

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

findname / fn: Fnids a file in the current project tree.  Example:
    $ fn find
    /home/wizzat/work/shell/find_unused_python.sh
    /home/wizzat/work/shell/find_up
    /home/wizzat/work/shell/find_up_dir
    /home/wizzat/work/shell/findname

format\_sql\_block.pl: A utility script I use to format SQL in a certain way.  The biggest remaining todo is to detect and align on AS blocks.  It integrates into vim with:
    map ,fs :!~/bin/format_sql_block.pl<CR>

rim: A utility script which takes care of vim --remote --servername DEV for me.  Special usage: rim -t finds a file in your current project and rim's it.  Examples:
    $ rim find_up
    mvim --servername DEV --remote find_up

    $ rim -t find # Find a file somewhere downstream of me.
    mvim --servername DEV --remote /home/wizzat/work/shell/find_up
    mvim --servername DEV --remote /home/wizzat/work/shell/find_up_dir
    mvim --servername DEV --remote /home/wizzat/work/shell/find_unused_python.sh
    mvim --servername DEV --remote /home/wizzat/work/shell/findname

    $ fn find | rim # rim also reads from stdin, which allows it to chain nicely with ack -l, ack_and, ack_not, and fn.
    mvim --servername DEV --remote /home/wizzat/work/shell/find_up
    mvim --servername DEV --remote /home/wizzat/work/shell/find_up_dir
    mvim --servername DEV --remote /home/wizzat/work/shell/find_unused_python.sh
    mvim --servername DEV --remote /home/wizzat/work/shell/findname
    
tableize.pl: A utility script which I use to tableize certain blocks of code.  It integrates into vim with:
    map ,wt :perldo s/\s+$//g<CR>:perldo s/\t/    /g<CR>
    map ,a  :!~/work/shell/tableize.pl<CR>,wt<CR>

cdots.sh: A shell utility that I use heavily.  It has its own license (GPL).

LICENSE: MIT, except for cdots.sh which has its own license.

Many of the perl modules will require some of:
- Try::Tiny
- File::Slurp
- DBI
- DBD::Oracle
- Exporter::Easy
- Text::CSV
- DateTime
- File::Basename
- File::Spec (should come with perl)
- Getopt::Long (should come with perl)
- Carp (should come with perl)
- IO::File (should come with perl)
