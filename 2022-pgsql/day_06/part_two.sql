select i + s
from
    unnest(regexp_split_to_array(pg_read_file('/data/day_06/input.txt'), '')) with ordinality c(p, i),
    generate_series(0, 13) s
group by i + s
having count(distinct p) = 14
order by i + s
limit 1;
