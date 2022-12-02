create table strategy
(
    id       serial,
    opponent char not null,
    me       char not null,

    primary key (id)
);

copy strategy (opponent, me) from '/data/day_02/input.txt' delimiter ' ';

select sum(
    case
        when me = 'X' then 1
        when me = 'Y' then 2
        when me = 'Z' then 3
    end
    +
    case
        when opponent = 'A' and me = 'Y' then 6
        when opponent = 'B' and me = 'Z' then 6
        when opponent = 'C' and me = 'X' then 6
        when opponent = 'A' and me = 'X' then 3
        when opponent = 'B' and me = 'Y' then 3
        when opponent = 'C' and me = 'Z' then 3
        else 0
    end
)
from strategy;

drop table strategy;
