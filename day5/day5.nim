#Advent of Code 2021 Day 5

from math import sgn
import strscans

const ARRAY_SIZE = 1000
type Vents = array[ARRAY_SIZE, array[ARRAY_SIZE, int]]

proc day5(allowing_diagonals: bool) =
    var vents: Vents
    var count = 0
    for line in lines("input.txt"):
        let (success, x1, y1, x2, y2) = scanTuple(line, "$i,$i -> $i,$i")
        if success:
            if not allowing_diagonals and x1 != x2 and y1 != y2:
                continue
            let dx = sgn(x2 - x1)
            let dy = sgn(y2 - y1)
            var x = x1
            var y = y1
            while true:
                let should_break = (x == x2 and y == y2)
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
