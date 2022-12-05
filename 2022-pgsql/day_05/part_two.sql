create table input
(
    id   serial,
    line text not null,

    primary key (id)
);

copy input (line) from '/data/day_05/input.txt';

create table crate
(
    stack int not null,
    pos   int not null,
    val   char not null,

    primary key (stack, pos)
);

do $$
declare
    stack_row_id int;
    cmd          int[];
    create_pos   int;
begin
    stack_row_id := (select (regexp_match(line, '\s([0-9]+)\s*$'))[1] from input where id = (select id from input where line = '') - 1);
    insert into crate (stack, pos, val)
    select
        stack,
        row_number() over (partition by stack order by i.id desc),
        substring(line from ((stack - 1) * 4 + 2) for 1)
    from generate_series(1, stack_row_id) stack
    join input i on i.id < stack_row_id
    where substring(line from ((stack - 1) * 4 + 2) for 1) != ' ';

    for cmd in select regexp_match(line, 'move (\d+) from (\d+) to (\d+)') from input where id > 9 + 1 order by id
    loop
        for create_pos in select pos from (select pos from crate where stack = cmd[2] order by pos desc limit cmd[1]) s order by s.pos
        loop
            update crate set stack = cmd[3], pos = (select coalesce(max(pos), 0) from crate where stack = cmd[3]) + 1 where stack = cmd[2] and pos = create_pos;
        end loop;
    end loop;
end;
$$;

select
    string_agg(val, '')
from (select stack, val, row_number() over (partition by stack order by pos desc) as i from crate) s
where s.i = 1;

drop table crate;
drop table input;
