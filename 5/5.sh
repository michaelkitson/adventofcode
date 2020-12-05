#! bash
set -euo pipefail

binary=`cat input.txt | tr FBLR 0101`

function sorted {
  for i in $binary; do
    echo $((2#$i))
  done | sort -n
}
all=`sorted`
max=`sorted | tail -n 1`
min=`sorted | head -n 1`

echo "Part 1: $max"

echo -n "Part 2: "
comm -23 <(seq $min $max) <(sorted)
