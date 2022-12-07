create function norm_path(parts text[])
    returns text[]
    language plpgsql
as $$
declare
    part    text;
    result  text[];
begin
    foreach part in array parts
    loop
        if part = '..' then
            result = trim_array(result, 1);
        else
            result = result || part;
        end if;
    end loop;

    return result;
end;
$$;

with
    log as (
        select
            i,
            substring(line, ' (.*?)\n') as cmd,
            substring(line, '\n(.*)\n') as output
        from unnest(string_to_array(pg_read_file('/data/day_07/input.txt'), '$')) with ordinality _(line, i)
        where line != ''
    ),
    file as (
        select
            norm_path(dir) as dir,
            substring(file, ' (.*)') as name,
            substring(file, '\d+')::int as size
        from
            log l,
            unnest(string_to_array(l.output, E'\n')) file
            cross join lateral (select array_agg(substring(cmd from 4)) from log where i < l.i and cmd like 'cd%' order by l.i) _(dir)
        where l.cmd = 'ls' and file not like 'dir %'
    ),
    dir as (
        select distinct array_agg(p) over (partition by dir, name rows unbounded preceding) as parts
        from file, unnest(dir) p
    ),
    small_dir as (
        select d.parts, sum(f.size) as size
        from dir d
        join file f on f.dir[1:cardinality(d.parts)] = d.parts
        group by d.parts
        having sum(f.size) <= 100000
    )
select sum(size) from small_dir;

drop function norm_path(parts text[]);
