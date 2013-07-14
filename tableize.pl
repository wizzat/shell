#!/usr/bin/perl -w
use strict;

use List::Util qw/ min max /;
use Text::CSV;

my $should_calculate_margin = 1;

sub tableize {
    my (@rows, %field_width, $margin, @terminators);
    my $csv = _csv();

    while (my $line = <STDIN>) {
        $margin = calculate_margin($line)
            if $should_calculate_margin;

        my @wrapper_tokens = get_wrapper_tokens(\$line, $margin);
        my @fields         = parse_csv($csv, $line);

        maintain_field_widths(\%field_width, \@fields);

        push(@terminators, @wrapper_tokens);
        push(@rows,        [ @fields ]);
    }
    print_with_size(\@rows, \%field_width, \@terminators);
}

sub parse_csv {
    my ($csv, $line, $field_width) = @_;

    unless ($csv->parse($line)) {
        warn "Unable to parse CSV: $line, Invalid field: " . $csv->error_input();
        return;
    }

    return $csv->fields();
}

sub maintain_field_widths {
    my ($field_width, $field_ref) = @_;

    for (my $i = 0; $i < scalar @$field_ref; ++$i) {
        my $contents = \$field_ref->[$i];
        $$contents =~ s/^ +//;
        $$contents =~ s/ +$//;

        $field_width->{$i} = max($field_width->{$i} || 0, length($$contents) + 1);
    }
}

sub get_wrapper_tokens {
    my ($line, $margin) = @_;

    my $open_tokens  = '';
    my $close_tokens = '';

    $$line =~ s/^ +//;
    if ($$line =~ s/^([\(\[{ ]+)//) {
        $open_tokens = $1;
        $open_tokens =~ s/  / /g;
    }

    $open_tokens = sprintf("%${margin}s%s", "", $open_tokens);

    if ($$line =~ s/([,}) ]+)$//) {
        $close_tokens = $1;
        $close_tokens =~ s/  / /g;
        $close_tokens =~ s/ +$//;
    }

    return [ $open_tokens, $close_tokens ];
}

sub print_with_size {
    my ($rows, $field_width, $terminators) = @_;

    my @widths      = map { $field_width->{$_} } sort keys %{$field_width};

    foreach my $row (@$rows) {
        my $line_terminators           = shift @$terminators;
        my $num_columns                = scalar @$row;
        my ($open_token, $close_token) = @$line_terminators;
        my @columns;

        foreach my $column (0..$num_columns-1) {
            my $width = $widths[$column];
            push(@columns, sprintf("%-${width}s", $row->[$column]));
        }

        my $final_string = $open_token . join(", ", @columns) . $close_token . "\n";
        $final_string =~ s/( +),/,$1/g;
        $final_string =~ s/ +$//;

        print $final_string;
    }
}

sub calculate_margin {
    my $row    = shift;
    my ($margin) = $row =~ /^( *)/;

    $should_calculate_margin = 0;

    return length($margin);
}

sub _csv {
    return Text::CSV->new ({
        quote_char          => "\0",
        escape_char         => "\0",
        sep_char            => ',',
        eol                 => $\,
        always_quote        => 0,
        quote_space         => 0,
        quote_null          => 0,
        binary              => 0,
        keep_meta_info      => 0,
        allow_loose_quotes  => 0,
        allow_loose_escapes => 0,
        allow_whitespace    => 0,
        blank_is_undef      => 0,
        empty_is_undef      => 0,
        verbatim            => 0,
        auto_diag           => 0,
    }) or die "Cannot use CSV: " . Text::CSV->error_diag ();
}

tableize();
