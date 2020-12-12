import sequtils, strutils

let entireFile = readFile("input.txt")
let instructions = filter(splitLines(entireFile), proc (l: string): bool = len(l) > 0)
var deg = 90
var n = 0
var e = 0
for instruction in instructions:
  var dir = instruction[0]
  let value = parseInt(instruction[1..^1])
  if dir == 'F':
    dir = ['N', 'E', 'S', 'W'][int(deg / 90)]
  case dir:
    of 'N':
      n += value
    of 'E':
      e += value
    of 'S':
      n -= value
    of 'W':
      e -= value
    of 'L':
      deg -= value
      while deg < 0:
        deg += 360
    of 'R':
      deg = (deg + value) mod 360
    else:
      echo "unhandled instruction $#" % instruction

var n2 = 0
var e2 = 0
var waypoint_n = 1
var waypoint_e = 10
for instruction in instructions:
  var value = parseInt(instruction[1..^1])
  case instruction[0]:
    of 'N':
      waypoint_n += value
    of 'E':
      waypoint_e += value
    of 'S':
      waypoint_n -= value
    of 'W':
      waypoint_e -= value
    of 'L':
      while value > 0:
        let temp_e = waypoint_e
        waypoint_e = -waypoint_n
        waypoint_n = temp_e
        value -= 90
    of 'R':
      while value > 0:
        let temp_n = waypoint_n
        waypoint_n = -waypoint_e
        waypoint_e = temp_n
        value -= 90
    of 'F':
      n2 += waypoint_n * value
      e2 += waypoint_e * value
    else:
      echo "unhandled instruction $#" % instruction

echo "Part 1: $#" % $(abs(n) + abs(e))
echo "Part 2: $#" % $(abs(n2) + abs(e2))
