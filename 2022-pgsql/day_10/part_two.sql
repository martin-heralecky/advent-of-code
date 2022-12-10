with program as (
    select
        coalesce(sum(substring(row, ' (.*)')::int * i) over (rows unbounded preceding exclude current row), 0) + 1 as x,
        row_number() over () - 1 as p
    from
        unnest(string_to_array(trim(pg_read_file('/data/day_10/input.txt'), E'\n'), E'\n')) row,
        generate_series(0, translate(row::char, 'na', '01')::int) i
)
select string_agg(chr(((abs(p % 40 - x) < 2)::int + 1) * 32), '')
from program
group by p / 40
order by p / 40;
