#!/bin/bash

# This solution works much faster because it runs VACUUM before each chunk.

psql -qAtf day_11/part_two_quick_pre.sql

for _ in {1..100}; do
  psql -qAtf day_11/part_two_quick_chunk.sql
done

psql -qAtf day_11/part_two_quick_post.sql
