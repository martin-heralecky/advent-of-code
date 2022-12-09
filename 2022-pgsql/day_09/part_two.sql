create or replace function compute()
    returns text[]
    language plpgsql
as $$
declare
    dir       char;
    k         int[][] := '{{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}}';
    tail_path text[]  := '{0:0}';
begin
    for dir in
        select substring(row for 1)
        from
            unnest(string_to_array(trim(pg_read_file('/data/day_09/input.txt'), E'\n'), E'\n')) row,
            generate_series(1, substring(row from 3)::int) __
    loop
        k[1][1] = k[1][1] + (select translate(dir, 'RLUD', '2011')::int - 1);
        k[1][2] = k[1][2] + (select translate(dir, 'RLUD', '1120')::int - 1);

        for i in 2..10
        loop
            if (abs(k[i-1][1] - k[i][1]) > 1 or abs(k[i-1][2] - k[i][2]) > 1) then
                k[i][1] = k[i][1] + sign(k[i-1][1] - k[i][1]);
                k[i][2] = k[i][2] + sign(k[i-1][2] - k[i][2]);
            end if;
        end loop;

        tail_path = tail_path || (k[10][1] || ':' || k[10][2]);
    end loop;

    return tail_path;
end;
$$;

select count(distinct c) from unnest(compute()) c;

drop function compute();
