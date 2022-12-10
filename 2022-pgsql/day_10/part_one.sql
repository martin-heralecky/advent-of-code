with program as (
    select
        sum(substring(row, ' (.*)')::int * i) over (rows unbounded preceding exclude current row) + 1 as x,
        row_number() over () as p
    from
        unnest(string_to_array(trim(pg_read_file('/data/day_10/input.txt'), E'\n'), E'\n')) row,
        generate_series(0, translate(row::char, 'na', '01')::int) i
)
select sum(x * p) from program where (p - 20) % 40 = 0;
