#!/usr/bin/perl -w
use strict;

use File::Basename qw/
    dirname
    basename
    fileparse
/;

my $dryrun = 0;
my $quiet  = 1;

sub run_test {
    my $filename = shift;
    my ($base_file, $directory, $filetype) = fileparse($filename, qr/\.[^.]*?$/);

    if ($filetype eq '.java' || $filetype eq '.groovy') {
        fork() and return;

        my $class = get_class($filename);
        my $pom_dir = dirname(`find_up pom.xml`);
        my $profile = "-Pft";

        chdir($pom_dir)
            or die $!;
        if ($pom_dir =~ /datawarehouse/) {
            $profile = "-Pdw"
        }
        my $return = run_cmd("mvn -o clean install $profile -Dtest=$class 2>&1 > ~/work/test.out");# 2>&1 > /dev/null");
        my $failure_file = "target/surefire-reports/${class}.txt";

        if ($return != 0 && -e $failure_file) {
            run_cmd("screen -x dev -X eval 'screen less -RS $pom_dir/$failure_file' 'title $class' 'other'");
            #run_cmd("screen -x dev -X  -t $class 'screen less -RS $pom_dir/$failure_file' 'other'");
            #run_cmd("rim $pom_dir/$failure_file");
        }
    } else {
        print("Do not know how to test files of type $filetype");
    }
}

sub get_class {
    my $filename = shift;
    my $contents = `cat $filename`;

    my ($package) = $contents =~ /package (.*)/
        or die "Can't determine package";

    $package =~ s/;//;

    my ($class) = $contents =~ /public class (\w+) /
        or die "Can't determine class name";
    return "$package.$class";
}

for my $file (@ARGV) {
    run_test($file);
}

sub run_cmd {
    my $cmd = shift;

    if (!$quiet) {
        print("$cmd\n");
    }

    if (!$dryrun) {
        system($cmd);
    }
}

