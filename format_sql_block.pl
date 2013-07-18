#!/usr/bin/perl -w
use strict;

my @upper_words = qw/
    %notfound
    and
    as
    asc
    auto_increment
    begin
    between
    commit
    cursor
    date
    datetime
    declare
    desc
    distinct
    double
    else
    elsif
    end
    exists
    fetch
    float
    from
    function
    if
    in
    insert
    integer
    into
    is
    loop
    noparallel
    not
    null
    number
    or
    out
    package
    procedure
    return
    rollback
    select
    set
    smallint
    sysdate
    then
    timestamp
    unique
    update
    using
    values
    varchar
    varchar2
    where
/;

push(@upper_words,
    'execute immediate',
    'create index',
    'create table',
    'create sequence',
    'end if',
    'delete from',
    'exit when',
    'group by',
    'order by',
    'exception when',
    'case when',
    'sql%rowcount',
    'create or replace',
    'package body',
    'inner join',
    'left outer join',
    'on',
    'drop table',
    'drop sequence',
    'reuse storage',
    'truncate table',
    'primary key',
    'foreign key',
    'alter table',
    'add primary key',
    'add column',
);

while (<STDIN>) {
    $_ =~ s/\t/    /;
    foreach my $word (@upper_words) {
        $_ =~ s/\b$word\b/\U$word/ig;
    }
    print($_);
}
