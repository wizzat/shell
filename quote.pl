#!/usr/bin/perl -w
use strict;

while (<STDIN>) {
    $_ =~ s/^(\s*)(.*)(\s*)$/$1'$2'/;
    $_ =~ s/,'$/',/;
    $_ =~ s/'$/',/;
    print("$_\n");
}
