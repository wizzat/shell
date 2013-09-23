#!/usr/bin/perl
use strict;
use warnings;

# I modified this from here: http://stackoverflow.com/questions/1063125/linux-tool-to-parse-csv-files

use Getopt::Long;
use Text::CSV_XS;

my $column_string = '';
GetOptions("field=s" => \$column_string)
  or die "Failed parsing options\n";
die "Must give at least one -field\n" unless $column_string;

# convert 1-based to 0-based
my @opt_columns = map { int($_)-1 } split /,/, $column_string;

my $csv = Text::CSV_XS->new ( { binary => 1 } );

open(my $stdin, "<-") or die "Couldn't open stdin\n";
open(my $stdout, ">-") or die "Couldn't open stdout\n";

while (my $row = $csv->getline($stdin)) {
    my @nrow = @{$row}[@opt_columns];
    $csv->print($stdout, \@nrow);
    print "\n";
}
