# Advent of Code 2021 Day 5

from strutils import parseInt
import re
import sequtils

const ARRAY_SIZE = 1000
type Vents = array[ARRAY_SIZE, array[ARRAY_SIZE, int]]

proc sign(num: int): int =
    if num == 0:
        return 0
    else:
        return int(num / abs(num))

proc day5(allowing_diagonals: bool) =
    var vents: Vents
    var count = 0
    for line in lines("input.txt"):
        # Theoretically 'matches' can be a seq, but I couldn't figure out how
        var matches: array[4, string]
        if match(line, re"(\d+),(\d+) -> (\d+),(\d+)", matches):
            let pts = toSeq(matches).map(parseInt)
            if not allowing_diagonals and pts[0] != pts[2] and pts[1] != pts[3]:
                continue
            let dx = sign(pts[2] - pts[0])
            let dy = sign(pts[3] - pts[1])
            var x = pts[0]
            var y = pts[1]
            while true:
                let should_break = (x == pts[2] and y == pts[3])
                inc(vents[x][y])
                if vents[x][y] == 2:
                    inc(count)
                if should_break:
                    break
                x += dx
                y += dy
    echo(count)

day5(false) # Part 1
day5(true)  # Part 2
