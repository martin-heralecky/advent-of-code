create function isnum(c char)
    returns bool
    return c in ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a');

create function split(str text)
    returns text[]
    language plpgsql
as $$
declare
    i int := 1;
    c char;
    start int := null;
    depth int := 0;
    items text[] := '{}';
begin
    if (substring(str from i for 1) != '[') then
        raise exception 'str does not start with [: %', str;
    end if;

    i = i + 1;

    loop
        c = substring(str from i for 1);

        if (depth = 0) then
            if (start is not null) then
                items = items || substring(str from start for i - start);
                start = null;
            end if;

            if (isnum(c)) then
                items = items || c;
            elseif (c = '[') then
                start = i;
                depth = depth + 1;
            else
                return items;
            end if;
        elseif (depth > 0) then
            if (c = '[') then
                depth = depth + 1;
            elseif (c = ']') then
                depth = depth - 1;
            end if;
        end if;

        i = i + 1;
    end loop;
end;
$$;

create function cmp(lhs text, rhs text)
    returns int
    language plpgsql
as $$
declare
    i int    := 1;
    l text[] := split(lhs);
    r text[] := split(rhs);
    cmp int;
begin
    loop
        if (l[i] is null) then
            if (r[i] is null) then
                return 0;
            else
                return -1;
            end if;
        elseif (r[i] is null) then
            return 1;
        end if;

        if (isnum(l[i])) then
            if (isnum(r[i])) then
                if (l[i] < r[i]) then
                    return -1;
                elseif (l[i] > r[i]) then
                    return 1;
                end if;
            else
                cmp = cmp('[' || l[i] || ']', r[i]);
                if (cmp != 0) then
                    return cmp;
                end if;
            end if;
        elseif (isnum(r[i])) then
            cmp = cmp(l[i], '[' || r[i] || ']');
            if (cmp != 0) then
                return cmp;
            end if;
        else
            cmp = cmp(l[i], r[i]);
            if (cmp != 0) then
                return cmp;
            end if;
        end if;

        i = i + 1;
    end loop;
end;
$$;

select sum(i)
from unnest(
    string_to_array(replace(replace(trim(pg_read_file('/data/day_13/input.txt'), E'\n'), '10', 'a'), ',', ''), E'\n\n')
) with ordinality _(row, i)
where cmp(substring(row, '(.*)\n'), substring(row, '\n(.*)')) = -1;

drop function cmp(text, text);
drop function split(text);
drop function isnum(char);
