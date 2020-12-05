#! bash
set -euo pipefail

binary=`cat input.txt | tr FBLR 0101`

function sorted {
  for i in $binary; do
    echo $((2#$i))
  done | sort -n
}
max=`sorted | tail -n 1`
min=`sorted | head -n 1`
missing=`comm -23 <(seq $min $max) <(sorted)`
echo "Part 1: $max"
echo "Part 2: $missing"
