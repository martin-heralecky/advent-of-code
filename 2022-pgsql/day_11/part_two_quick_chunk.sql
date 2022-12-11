vacuum;

do $$
declare
    m     record;
    i     record;
    lcm   bigint;
    new_w bigint;
begin
    lcm = (select lcm_agg(div) from monkey);

    for _ in 1..100
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
