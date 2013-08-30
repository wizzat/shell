#!/usr/bin/perl -w
use strict;

open FH, "| testdb";
while (<STDIN>) {
    print FH $_;
}
print FH "commit;\n";
