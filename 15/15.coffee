game = (initial) ->
  map = {}
  index = 1
  for x in initial
    map[last] = index - 1
    last = x
    yield x
    index++

  loop
    next = if map[last] then index - map[last] - 1 else 0
    map[last] = index - 1
    last = next
    yield next
    index++
  null

nth = (gen, n) ->
  i = 1
  until i == n + 1
    val = gen.next().value
    i++
  val

console.log("Part 1:", nth(game([19,0,5,1,10,13]), 2020))
console.log("Part 2:", nth(game([19,0,5,1,10,13]), 30000000))
