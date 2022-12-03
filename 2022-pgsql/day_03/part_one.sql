create table rucksack
(
    id      serial,
    content text not null,

    primary key (id)
);

copy rucksack (content) from '/data/day_03/input.txt';

select sum(
    (position('a' in substring(content for length(content) / 2)) > 0 and position('a' in substring(content from length(content) / 2 + 1)) > 0)::int * 1
    + (position('b' in substring(content for length(content) / 2)) > 0 and position('b' in substring(content from length(content) / 2 + 1)) > 0)::int * 2
    + (position('c' in substring(content for length(content) / 2)) > 0 and position('c' in substring(content from length(content) / 2 + 1)) > 0)::int * 3
    + (position('d' in substring(content for length(content) / 2)) > 0 and position('d' in substring(content from length(content) / 2 + 1)) > 0)::int * 4
    + (position('e' in substring(content for length(content) / 2)) > 0 and position('e' in substring(content from length(content) / 2 + 1)) > 0)::int * 5
    + (position('f' in substring(content for length(content) / 2)) > 0 and position('f' in substring(content from length(content) / 2 + 1)) > 0)::int * 6
    + (position('g' in substring(content for length(content) / 2)) > 0 and position('g' in substring(content from length(content) / 2 + 1)) > 0)::int * 7
    + (position('h' in substring(content for length(content) / 2)) > 0 and position('h' in substring(content from length(content) / 2 + 1)) > 0)::int * 8
    + (position('i' in substring(content for length(content) / 2)) > 0 and position('i' in substring(content from length(content) / 2 + 1)) > 0)::int * 9
    + (position('j' in substring(content for length(content) / 2)) > 0 and position('j' in substring(content from length(content) / 2 + 1)) > 0)::int * 10
    + (position('k' in substring(content for length(content) / 2)) > 0 and position('k' in substring(content from length(content) / 2 + 1)) > 0)::int * 11
    + (position('l' in substring(content for length(content) / 2)) > 0 and position('l' in substring(content from length(content) / 2 + 1)) > 0)::int * 12
    + (position('m' in substring(content for length(content) / 2)) > 0 and position('m' in substring(content from length(content) / 2 + 1)) > 0)::int * 13
    + (position('n' in substring(content for length(content) / 2)) > 0 and position('n' in substring(content from length(content) / 2 + 1)) > 0)::int * 14
    + (position('o' in substring(content for length(content) / 2)) > 0 and position('o' in substring(content from length(content) / 2 + 1)) > 0)::int * 15
    + (position('p' in substring(content for length(content) / 2)) > 0 and position('p' in substring(content from length(content) / 2 + 1)) > 0)::int * 16
    + (position('q' in substring(content for length(content) / 2)) > 0 and position('q' in substring(content from length(content) / 2 + 1)) > 0)::int * 17
    + (position('r' in substring(content for length(content) / 2)) > 0 and position('r' in substring(content from length(content) / 2 + 1)) > 0)::int * 18
    + (position('s' in substring(content for length(content) / 2)) > 0 and position('s' in substring(content from length(content) / 2 + 1)) > 0)::int * 19
    + (position('t' in substring(content for length(content) / 2)) > 0 and position('t' in substring(content from length(content) / 2 + 1)) > 0)::int * 20
    + (position('u' in substring(content for length(content) / 2)) > 0 and position('u' in substring(content from length(content) / 2 + 1)) > 0)::int * 21
    + (position('v' in substring(content for length(content) / 2)) > 0 and position('v' in substring(content from length(content) / 2 + 1)) > 0)::int * 22
    + (position('w' in substring(content for length(content) / 2)) > 0 and position('w' in substring(content from length(content) / 2 + 1)) > 0)::int * 23
    + (position('x' in substring(content for length(content) / 2)) > 0 and position('x' in substring(content from length(content) / 2 + 1)) > 0)::int * 24
    + (position('y' in substring(content for length(content) / 2)) > 0 and position('y' in substring(content from length(content) / 2 + 1)) > 0)::int * 25
    + (position('z' in substring(content for length(content) / 2)) > 0 and position('z' in substring(content from length(content) / 2 + 1)) > 0)::int * 26
    + (position('A' in substring(content for length(content) / 2)) > 0 and position('A' in substring(content from length(content) / 2 + 1)) > 0)::int * 27
    + (position('B' in substring(content for length(content) / 2)) > 0 and position('B' in substring(content from length(content) / 2 + 1)) > 0)::int * 28
    + (position('C' in substring(content for length(content) / 2)) > 0 and position('C' in substring(content from length(content) / 2 + 1)) > 0)::int * 29
    + (position('D' in substring(content for length(content) / 2)) > 0 and position('D' in substring(content from length(content) / 2 + 1)) > 0)::int * 30
    + (position('E' in substring(content for length(content) / 2)) > 0 and position('E' in substring(content from length(content) / 2 + 1)) > 0)::int * 31
    + (position('F' in substring(content for length(content) / 2)) > 0 and position('F' in substring(content from length(content) / 2 + 1)) > 0)::int * 32
    + (position('G' in substring(content for length(content) / 2)) > 0 and position('G' in substring(content from length(content) / 2 + 1)) > 0)::int * 33
    + (position('H' in substring(content for length(content) / 2)) > 0 and position('H' in substring(content from length(content) / 2 + 1)) > 0)::int * 34
    + (position('I' in substring(content for length(content) / 2)) > 0 and position('I' in substring(content from length(content) / 2 + 1)) > 0)::int * 35
    + (position('J' in substring(content for length(content) / 2)) > 0 and position('J' in substring(content from length(content) / 2 + 1)) > 0)::int * 36
    + (position('K' in substring(content for length(content) / 2)) > 0 and position('K' in substring(content from length(content) / 2 + 1)) > 0)::int * 37
    + (position('L' in substring(content for length(content) / 2)) > 0 and position('L' in substring(content from length(content) / 2 + 1)) > 0)::int * 38
    + (position('M' in substring(content for length(content) / 2)) > 0 and position('M' in substring(content from length(content) / 2 + 1)) > 0)::int * 39
    + (position('N' in substring(content for length(content) / 2)) > 0 and position('N' in substring(content from length(content) / 2 + 1)) > 0)::int * 40
    + (position('O' in substring(content for length(content) / 2)) > 0 and position('O' in substring(content from length(content) / 2 + 1)) > 0)::int * 41
    + (position('P' in substring(content for length(content) / 2)) > 0 and position('P' in substring(content from length(content) / 2 + 1)) > 0)::int * 42
    + (position('Q' in substring(content for length(content) / 2)) > 0 and position('Q' in substring(content from length(content) / 2 + 1)) > 0)::int * 43
    + (position('R' in substring(content for length(content) / 2)) > 0 and position('R' in substring(content from length(content) / 2 + 1)) > 0)::int * 44
    + (position('S' in substring(content for length(content) / 2)) > 0 and position('S' in substring(content from length(content) / 2 + 1)) > 0)::int * 45
    + (position('T' in substring(content for length(content) / 2)) > 0 and position('T' in substring(content from length(content) / 2 + 1)) > 0)::int * 46
    + (position('U' in substring(content for length(content) / 2)) > 0 and position('U' in substring(content from length(content) / 2 + 1)) > 0)::int * 47
    + (position('V' in substring(content for length(content) / 2)) > 0 and position('V' in substring(content from length(content) / 2 + 1)) > 0)::int * 48
    + (position('W' in substring(content for length(content) / 2)) > 0 and position('W' in substring(content from length(content) / 2 + 1)) > 0)::int * 49
    + (position('X' in substring(content for length(content) / 2)) > 0 and position('X' in substring(content from length(content) / 2 + 1)) > 0)::int * 50
    + (position('Y' in substring(content for length(content) / 2)) > 0 and position('Y' in substring(content from length(content) / 2 + 1)) > 0)::int * 51
    + (position('Z' in substring(content for length(content) / 2)) > 0 and position('Z' in substring(content from length(content) / 2 + 1)) > 0)::int * 52
)
from rucksack;

drop table rucksack;

