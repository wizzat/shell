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
    boolean
    cascade
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
    having
    if
    in
    insert
    integer
    into
    is
    like
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
    returning
    rollback
    select
    set
    smallint
    sysdate
    then
    timestamp
    truncate
    type
    union
    unique
    update
    using
    values
    varchar
    varchar2
    where
/;

push(@upper_words,
    'add column',
    'add primary key',
    'alter table',
    'alter column',
    'case when',
    'create index',
    'create or replace',
    'create sequence',
    'create table',
    'create temp table',
    'create temporary table',
    'delete from',
    'drop sequence',
    'drop table',
    'end if',
    'exception when',
    'execute immediate',
    'exit when',
    'for update',
    'for update nowait',
    'foreign key',
    'group by',
    'inner join',
    'left outer join',
    'on',
    'order by',
    'package body',
    'primary key',
    'reuse storage',
    'sql%rowcount',
    'truncate table',
    'union all',
);

while (<STDIN>) {
    $_ =~ s/\t/    /;
    foreach my $word (@upper_words) {
        $_ =~ s/\b$word\b/\U$word/ig;
    }
    print($_);
}
