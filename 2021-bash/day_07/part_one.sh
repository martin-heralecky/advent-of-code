#!/bin/bash

set -e

# cat input.txt | wc -l # 1000
# cat input.txt | tr , '\n' | sort -n | head -n 501 | tail -n 2 # 321 321

pos=321

cat input.txt | tr , '\n' | sed "s/\$/-$pos/" | xargs -I {} sh -c "echo {} | bc" | sed 's/-//' | paste -sd+ - | bc
