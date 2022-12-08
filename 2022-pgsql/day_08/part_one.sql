with tree as (
    select row, col, height
    from
        unnest(string_to_array(trim(pg_read_file('/data/day_08/input.txt'), E'\n'), E'\n')) with ordinality _(line, row),
        unnest(regexp_split_to_array(line, '')) with ordinality __(height, col)
)
select count(*)
from
    tree t,
    lateral (select max(height) from tree where col = t.col and row < t.row) u,
    lateral (select max(height) from tree where col = t.col and row > t.row) d,
    lateral (select max(height) from tree where col < t.col and row = t.row) l,
    lateral (select max(height) from tree where col > t.col and row = t.row) r
where
       u.max is null or u.max < t.height
    or d.max is null or d.max < t.height
    or l.max is null or l.max < t.height
    or r.max is null or r.max < t.height;
