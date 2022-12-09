create or replace function compute()
    returns text[]
    language plpgsql
as $$
declare
    dir       char;
    hx        int    := 0;
    hy        int    := 0;
    tx        int    := 0;
    ty        int    := 0;
    tail_path text[] := '{0:0}';
begin
    for dir in
        select substring(row for 1)
        from
            unnest(string_to_array(trim(pg_read_file('/data/day_09/input.txt'), E'\n'), E'\n')) row,
            generate_series(1, substring(row from 3)::int) __
    loop
        if (dir = 'R') then
            if (tx < hx) then
                tx = tx + 1;
                ty = hy;
            end if;

            hx = hx + 1;
        elseif (dir = 'L') then
            if (tx > hx) then
                tx = tx - 1;
                ty = hy;
            end if;

            hx = hx - 1;
        elseif (dir = 'U') then
            if (ty < hy) then
                ty = ty + 1;
                tx = hx;
            end if;

            hy = hy + 1;
        elseif (dir = 'D') then
            if (ty > hy) then
                ty = ty - 1;
                tx = hx;
            end if;

            hy = hy - 1;
        end if;

        tail_path = tail_path || (tx || ':' || ty);
    end loop;

    return tail_path;
end;
$$;

select count(distinct c) from unnest(compute()) c;

drop function compute();
