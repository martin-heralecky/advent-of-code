with tree as (
    select row, col, height
    from
        unnest(string_to_array(trim(pg_read_file('/data/day_08/input.txt'), E'\n'), E'\n')) with ordinality _(line, row),
        unnest(regexp_split_to_array(line, '')) with ordinality __(height, col)
)
select max(coalesce(u.dist, t.row - 1) * coalesce(d.dist, 99 - t.row) * coalesce(l.dist, t.col - 1) * coalesce(r.dist, 99 - t.col))
from
    tree t
    left join lateral (select t.row - row as dist from tree where col = t.col and row < t.row and height >= t.height order by row desc limit 1) u on true
    left join lateral (select row - t.row as dist from tree where col = t.col and row > t.row and height >= t.height order by row limit 1) d on true
    left join lateral (select t.col - col as dist from tree where col < t.col and row = t.row and height >= t.height order by col desc limit 1) l on true
    left join lateral (select col - t.col as dist from tree where col > t.col and row = t.row and height >= t.height order by col limit 1) r on true;
