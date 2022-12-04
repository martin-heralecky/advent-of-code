create table assignment
(
    id serial,
    a  text not null,
    b  text not null,

    primary key (id)
);

copy assignment (a, b) from '/data/day_04/input.txt' delimiter ',';

select
    sum(
        (not (
            (split_part(b, '-', 1)::int > split_part(a, '-', 2)::int)
            or (split_part(b, '-', 2)::int < split_part(a, '-', 1)::int)
        ))::int
    )
from assignment;

drop table assignment;
