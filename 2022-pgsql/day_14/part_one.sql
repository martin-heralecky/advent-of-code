create table map (x int, y int, primary key (x, y));

insert into map
with
    line_dirty as (
        select min(p) over (partition by i order by j rows 1 preceding exclude current row) a, p as b
        from
            unnest(string_to_array(trim(pg_read_file('/data/day_14/input.txt'), E'\n'), E'\n')) with ordinality _(row, i),
            unnest(string_to_array(row, ' -> ')) with ordinality __(p, j)
    ),
    line as (
        select
            substring(a, '(.*),')::int as ax,
            substring(a, ',(.*)')::int as ay,
            substring(b, '(.*),')::int as bx,
            substring(b, ',(.*)')::int as by
        from line_dirty
        where a is not null
    )
select distinct x, y
from line, generate_series(least(ax, bx), greatest(ax, bx)) x, generate_series(least(ay, by), greatest(ay, by)) y;

create function compute()
    returns int
    language plpgsql
as $$
declare
    i  int := 0;
    _x int;
    _y int;
begin
    loop
        _x = 500;
        _y = 0;

        loop
            _y = (select min(y) from map where x = _x and y > _y);

            if (_y is null) then
                return i;
            end if;

            if ((select 1 from map where x = _x - 1 and y = _y) is null) then
                _x = _x - 1;
            elseif ((select 1 from map where x = _x + 1 and y = _y) is null) then
                _x = _x + 1;
            else
                insert into map values (_x, _y - 1);
                exit;
            end if;
        end loop;

        i = i + 1;
    end loop;
end;
$$;

select compute();

drop function compute();
drop table map;
