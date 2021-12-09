#!/bin/bash

set -e

cat input.txt | grep -oP '(?<= \| ).*' | tr ' ' '\n' | xargs -I{} bash -c "echo -n \"{} \" && echo -n {} | wc -c" | grep -P '2|3|4|7' | wc -l
