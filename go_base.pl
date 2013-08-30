#!/usr/bin/perl -w

use strict;
use File::Slurp;
use File::Basename qw/ dirname /;

fork() and exit(0);

my $contents = read_file($ARGV[0]);
my ($base_class) = $contents =~ /^public class .* extends ([\w.]+)/m
    or exit(0);

chdir(dirname(`find_up pom.xml`));
system("rim `findname '*$base_class*'` 2>&1 > /dev/null");
