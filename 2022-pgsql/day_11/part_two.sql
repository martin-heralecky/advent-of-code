-- This solution works, but takes forever to complete because of Postgres not vacuuming during computation.

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

do $$
declare
    m     record;
    i     record;
    lcm   bigint;
    new_w bigint;
begin
    lcm = (select lcm_agg(div) from monkey);

    for _ in 1..10000
    loop
        for m in select * from monkey order by id
        loop
            for i in select * from item where mid = m.id order by id
            loop
                new_w =
                    case when m.operation = '+' then
                        i.w + replace(m.operand, 'old', i.w::text)::bigint
                    else
                        i.w * replace(m.operand, 'old', i.w::text)::bigint
                    end;

                new_w = new_w % lcm;

                update item
                set
                    id  = nextval('item_id_seq'),
                    mid = case when new_w % m.div = 0 then m.mid_true else m.mid_false end,
                    w   = new_w
                where id = i.id;

                update monkey set inspections = inspections + 1 where id = m.id;
            end loop;
        end loop;
    end loop;
end;
$$;

select round(exp(sum(ln(inspections)))) from (select inspections from monkey order by inspections desc limit 2) m;

drop aggregate lcm_agg(bigint);
drop table item;
drop table monkey;
