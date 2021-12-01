# Advent of Code 2021 Day 1

from math import sum
from strutils import parseInt

const ARRAY_SIZE = 3
type RollingAverage = array[ARRAY_SIZE, int]

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
  var window: RollingAverage
  var array_idx = 0
  for line in lines("input.txt"):
    let depth = parseInt(line)
    window[array_idx mod ARRAY_SIZE] = depth
    inc(array_idx)
    let rolling_depth = sum(window)
    if rolling_depth > prev and array_idx >= ARRAY_SIZE:
      inc(increases)
    prev = rolling_depth
  echo(increases)

part1()
part2()
