#! lua

function parseline(line)
  -- Example: 18-19 k: kkkkkkkkkkkkkkkkkkm
  local range = string.sub(line, 0, string.find(line, '%s') - 1)
  local rest = string.sub(line, string.find(line, '%s') + 1)
  local pos1 = tonumber(string.sub(range, 0, string.find(line, '-') - 1))
  local pos2 = tonumber(string.sub(range, string.find(line, '-') + 1))
  local letter = string.sub(rest, 1, 1)
  local password = string.sub(rest, 4)

  return {pos1 = pos1, pos2 = pos2, letter = letter, password = password}
end

function testpart1(parsed)
  local count = 0
  for i = 0, #parsed.password, 1 do
    if string.sub(parsed.password, i, i) == parsed.letter then
      count = count + 1
    end
  end
  return parsed.pos1 <= count and count <= parsed.pos2
end

function testpart2(parsed)
  local letter1match = parsed.letter == string.sub(parsed.password, parsed.pos1, parsed.pos1)
  local letter2match = parsed.letter == string.sub(parsed.password, parsed.pos2, parsed.pos2)

  return letter1match and not letter2match or letter2match and not letter1match
end

local lines = io.lines('input.txt')

local part1matches = 0
local part2matches = 0

for line in lines do
  local parsed = parseline(line)
  if testpart1(parsed) then
    part1matches = part1matches + 1
  end
  if testpart2(parsed) then
    part2matches = part2matches + 1
  end
end

print("Part 1 Matches: " .. part1matches)
print("Part 2 Matches: " .. part2matches)
