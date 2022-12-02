create table strategy
(
    id       serial,
    opponent char not null,
    result   char not null,

    primary key (id)
);

copy strategy (opponent, result) from '/data/day_02/input.txt' delimiter ' ';

select sum(
    case
        when result = 'X' then (
            0 + case
                when opponent = 'A' then 3
                when opponent = 'B' then 1
                when opponent = 'C' then 2
            end
        )
        when result = 'Y' then (
            3 + case
                when opponent = 'A' then 1
                when opponent = 'B' then 2
                when opponent = 'C' then 3
            end
        )
        when result = 'Z' then (
            6 + case
                when opponent = 'A' then 2
                when opponent = 'B' then 3
                when opponent = 'C' then 1
            end
        )
    end
)
from strategy;

drop table strategy;
