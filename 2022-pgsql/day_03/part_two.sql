create table rucksack
(
    id      serial,
    content text not null,

    primary key (id)
);

copy rucksack (content) from '/data/day_03/input.txt';

select sum(priority) from (
    select
        (sum((position('a' in content) > 0)::int) = 3)::int * 1
        + (sum((position('b' in content) > 0)::int) = 3)::int * 2
        + (sum((position('c' in content) > 0)::int) = 3)::int * 3
        + (sum((position('d' in content) > 0)::int) = 3)::int * 4
        + (sum((position('e' in content) > 0)::int) = 3)::int * 5
        + (sum((position('f' in content) > 0)::int) = 3)::int * 6
        + (sum((position('g' in content) > 0)::int) = 3)::int * 7
        + (sum((position('h' in content) > 0)::int) = 3)::int * 8
        + (sum((position('i' in content) > 0)::int) = 3)::int * 9
        + (sum((position('j' in content) > 0)::int) = 3)::int * 10
        + (sum((position('k' in content) > 0)::int) = 3)::int * 11
        + (sum((position('l' in content) > 0)::int) = 3)::int * 12
        + (sum((position('m' in content) > 0)::int) = 3)::int * 13
        + (sum((position('n' in content) > 0)::int) = 3)::int * 14
        + (sum((position('o' in content) > 0)::int) = 3)::int * 15
        + (sum((position('p' in content) > 0)::int) = 3)::int * 16
        + (sum((position('q' in content) > 0)::int) = 3)::int * 17
        + (sum((position('r' in content) > 0)::int) = 3)::int * 18
        + (sum((position('s' in content) > 0)::int) = 3)::int * 19
        + (sum((position('t' in content) > 0)::int) = 3)::int * 20
        + (sum((position('u' in content) > 0)::int) = 3)::int * 21
        + (sum((position('v' in content) > 0)::int) = 3)::int * 22
        + (sum((position('w' in content) > 0)::int) = 3)::int * 23
        + (sum((position('x' in content) > 0)::int) = 3)::int * 24
        + (sum((position('y' in content) > 0)::int) = 3)::int * 25
        + (sum((position('z' in content) > 0)::int) = 3)::int * 26
        + (sum((position('A' in content) > 0)::int) = 3)::int * 27
        + (sum((position('B' in content) > 0)::int) = 3)::int * 28
        + (sum((position('C' in content) > 0)::int) = 3)::int * 29
        + (sum((position('D' in content) > 0)::int) = 3)::int * 30
        + (sum((position('E' in content) > 0)::int) = 3)::int * 31
        + (sum((position('F' in content) > 0)::int) = 3)::int * 32
        + (sum((position('G' in content) > 0)::int) = 3)::int * 33
        + (sum((position('H' in content) > 0)::int) = 3)::int * 34
        + (sum((position('I' in content) > 0)::int) = 3)::int * 35
        + (sum((position('J' in content) > 0)::int) = 3)::int * 36
        + (sum((position('K' in content) > 0)::int) = 3)::int * 37
        + (sum((position('L' in content) > 0)::int) = 3)::int * 38
        + (sum((position('M' in content) > 0)::int) = 3)::int * 39
        + (sum((position('N' in content) > 0)::int) = 3)::int * 40
        + (sum((position('O' in content) > 0)::int) = 3)::int * 41
        + (sum((position('P' in content) > 0)::int) = 3)::int * 42
        + (sum((position('Q' in content) > 0)::int) = 3)::int * 43
        + (sum((position('R' in content) > 0)::int) = 3)::int * 44
        + (sum((position('S' in content) > 0)::int) = 3)::int * 45
        + (sum((position('T' in content) > 0)::int) = 3)::int * 46
        + (sum((position('U' in content) > 0)::int) = 3)::int * 47
        + (sum((position('V' in content) > 0)::int) = 3)::int * 48
        + (sum((position('W' in content) > 0)::int) = 3)::int * 49
        + (sum((position('X' in content) > 0)::int) = 3)::int * 50
        + (sum((position('Y' in content) > 0)::int) = 3)::int * 51
        + (sum((position('Z' in content) > 0)::int) = 3)::int * 52
        as priority
    from rucksack
    group by (id - 1) / 3
) p;

drop table rucksack;
