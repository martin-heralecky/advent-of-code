select round(exp(sum(ln(inspections)))) from (select inspections from monkey order by inspections desc limit 2) m;

drop aggregate lcm_agg(bigint);
drop table item;
drop table monkey;
