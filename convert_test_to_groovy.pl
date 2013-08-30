#!/usr/bin/perl -w
use strict;

use IO::File;

use File::Basename qw/ dirname /;

my $dryrun = 0;
my $quiet  = 0;

sub usage {
    my @errors;

    push(@errors, "Errors:") if scalar @_;
    push(@errors, map { "    $_" } @_);

    return <<HERE;
Usage: convert_test_to_groovy.pl path/to/file
Run this from the project root - it will die if it doesn't have pom.xml in the current directory
@{[ join("\n", @errors) ]}
HERE
}

sub main {
    my $filename = verify_file();
    verify_pom();

    my $file_contents = convert_to_groovy(`cat $filename`);
    my $groovy_path   = get_groovy_path($filename);
    write_file($groovy_path, $file_contents);
    run_cmd("rm -f $filename");
}

sub convert_to_groovy {
    my $file_contents = join("", @_);

    $file_contents =~ s/\t/    /mg;
    $file_contents =~ s/ +$//mg;
    $file_contents =~ s/;$//mg;
    $file_contents =~ s/\){/) {/mg;
    $file_contents =~ s/if\(/if (/mg;
    $file_contents =~ s/\@SuppressWarning(.*.)//mg;
    $file_contents =~ s/\) throws .*Exception {$/) {/mg;

    return $file_contents;
}

sub get_groovy_path {
    my $filename = shift;
    my $groovy_filename = $filename;
    $groovy_filename =~ s/java/groovy/g;
    
    my $groovy_dirname = dirname($groovy_filename);
    run_cmd("mkdir -p $groovy_dirname");

    return $groovy_filename;
}

sub write_file {
    my ($filename, $file_contents) = @_;

    my $fh = IO::File->new($filename, "w");
    die "No FH" unless $fh;
    print $fh $file_contents;
    undef $fh;

    print("Successfully wrote new groovy file: $filename\n");
}

sub verify_file {
    my @errors;
    push(@errors, "No filename provided / Wrong arguments")
        unless scalar @ARGV == 1;

    my $filename = $ARGV[0];

    push(@errors, "Don't run on groovy tests")
        if $filename =~ /.groovy/;

    die usage(@errors) if scalar @errors;
    return $filename;
}

sub verify_pom {
    my @pom_files = split(/\n/, `find . -name 'pom.xml'`);
    my @errors;

    push(@errors, "Too many pom files") if scalar @pom_files > 1;
    push(@errors, "Wrong pom file") if $pom_files[0] ne './pom.xml';

    die usage(@errors) if scalar @errors;
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


main();
