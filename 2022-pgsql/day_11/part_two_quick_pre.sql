create table monkey (
    id          serial,
    operation   char,
    operand     text,
    div         int,
    mid_true    int,
    mid_false   int,
    orig_items  int[],
    inspections int
);

insert into monkey
select
    substring(row, '\d')::int,
    substring(row, 'old (.)'),
    substring(row, 'old . (.*?)\n'),
    substring(row, 'by (.*?)\n')::int,
    substring(row, 'true.*? (\d+)\n')::int,
    substring(row, 'false.*? (\d+)(\n|$)')::int,
    string_to_array(substring(row, 'items: (.*?)\n'), ', ')::int[],
    0
from
    unnest(string_to_array(pg_read_file('/data/day_11/input.txt'), E'\n\n')) row;

create table item (
    id  serial,
    mid int,
    w   bigint
);

insert into item (mid, w)
select id, unnest(orig_items) from monkey;

create aggregate lcm_agg(bigint)
(
    sfunc = lcm,
    stype = bigint
);
