#!/usr/bin/perl -w
use strict;

my @file_types = qw/
    java
    groovy
/;

sub main {
    foreach my $file_type (@file_types) {
        my @files = split(/\n/, `find . -name '*.$file_type'`);

        foreach my $file (@files) {
            chomp $file;

            my $package = `head $file`;
            my @errors;

            push(@errors, "Bad base directory")
                unless $file =~ $file_type;

            unless ($package =~ /.*(package .*)$/m) {
                push(@errors, "Unable to find package");
            } else {
                $package = $1;
                $package =~ s/;//;
                $package =~ s/\./\//g;
                $package =~ s/package //;

                push(@errors, "Directory does not match package: $package")
                    unless $file =~ /$package/;
            }

            display_errors($file, @errors);
        }
    }
}

sub display_errors {
    my ($file, @errors) = @_;
    print "$file has errors:\n    " . join("\n    ", @errors) . "\n\n"
        if @errors;
}

main();
