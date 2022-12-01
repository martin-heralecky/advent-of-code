create table food
(
    id       serial,
    calories int,

    primary key (id)
);

copy food (calories) from '/data/day_01/input.txt' null '';
insert into food (calories) values (null);

create function compute()
    returns integer
    language plpgsql
as $$
declare
    c       integer;
    current integer := 0;
    max     integer := 0;
begin
    for c in select calories from food order by id
    loop
        if c is null then
            max := greatest(current, max);
            current := 0;
        else
            current := current + c;
        end if;
    end loop;

    return max;
end;
$$;

select compute();

drop table food;
drop function compute();
