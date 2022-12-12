create table grid (x int, y int, v int, is_end bool, primary key (x, y));

insert into grid
select (i - 1) % 95, (i - 1) / 95, ascii(translate(v, 'E', 'z')), v = 'E'
from unnest(regexp_split_to_array(replace(pg_read_file('/data/day_12/input.txt'), E'\n', ''), '')) with ordinality _(v, i);

create table step (p int, i int, x int, y int);
    
insert into step
select row_number() over (), 0, x, y from grid where v = ascii('a');

do $$
declare
begin
    while (select 1 from step s join grid g on g.x = s.x and g.y = s.y where g.is_end limit 1) is null
    loop
        insert into step
        select distinct s.p, s.i + 1, g.x, g.y
        from step s
        join grid g_old on g_old.x = s.x and g_old.y = s.y
        join grid g on abs(g.y - s.y) + abs(g.x - s.x) = 1 and g.v - g_old.v < 2
        left join step prev on prev.x = g.x and prev.y = g.y
        where prev is null and s.i = (select max(i) from step);
    end loop;
end;
$$;

select max(i) from step;

drop table step;
drop table grid;
