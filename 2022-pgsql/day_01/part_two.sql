create table food
(
    id       serial,
    calories int,

    primary key (id)
);

copy food (calories) from '/data/day_01/input.txt' null '';
insert into food (calories) values (null);

create table food_total
(
    id       serial,
    calories int,

    primary key (id)
);

do $$
declare
    c       integer;
    current integer := 0;
begin
    for c in select calories from food order by id
    loop
        if c is null then
            insert into food_total (calories) values (current);
            current := 0;
        else
            current := current + c;
        end if;
    end loop;
end;
$$;

select sum(calories) from (select calories from food_total order by calories desc limit 3) s;

drop table food;
drop table food_total;
