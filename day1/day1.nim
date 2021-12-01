# Advent of Code 2021 Day 1

from strutils import parseInt

type RollingAverage = array[3, int]
type Windows = array[3, RollingAverage]

proc part1() =
  var increases = 0
  var prev = 9999
  for line in lines("input.txt"):
    let depth = parseInt(line)
    if depth > prev:
      inc(increases)
    prev = depth

  echo(increases)

proc part2() =
  var increases = 0
  var prev = 9999
  var window: Windows
  var array_idx = 0
  for line in lines("input.txt"):
    let depth = parseInt(line)
    for w in low(window)..high(window):
      let i = (array_idx + w) mod 3
      window[w][i] = depth
      if i == high(window[0]) and array_idx > 1:
        let rolling_depth = window[w][0] + window[w][1] + window[w][2]
        if rolling_depth > prev:
          inc(increases)
        prev = rolling_depth
    inc(array_idx)
  echo(increases)

part1()
part2()
