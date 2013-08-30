#!/usr/bin/perl -w
use strict;
use warnings;

use File::Basename 'basename';
use Set::Scalar;

$|=1;

# mroberts@eternity8$ find $PWD | grep '/src/test/' | grep -v 'Test.' | grep -v 'Integration.' | grep -v 'Long.' | zombie_code_killer.pl > ~/dependents
#

sub main {
    my @files = <STDIN>;
    my $file_set = Set::Scalar->new();
    foreach my $file (@files) {
        $file =~ s/\n//;
        $file = basename($file);
        $file_set->insert($file);
    }

    foreach my $file ($file_set->members()) {
        find_uses($file);
    }
}

sub find_uses {
    my ($filename) =  @_;
    my $CJMAIN     =  $ENV{CJMAIN};
    my $token      =  basename($filename);
    $token         =~ s/\.java//;

    chdir($CJMAIN);
    my @uses = split(/\n/, `grep -rl $token * | grep -v '/target/' | grep -ve '*xml'`);
    my $num_uses = scalar @uses;
    printf("%5d %50s\n", $num_uses, $token);
}

main();
