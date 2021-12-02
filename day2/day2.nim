# Advent of Code 2021 Day 2

from strutils import parseInt, split

proc part1() =
    var dx = 0
    var dy = 0
    for line in lines("input.txt"):
        let line_seq = line.split({' '})
        let dir = line_seq[0]
        let val = parseInt(line_seq[1])

        case dir:
            of "forward":
                dx += val
            of "down":
                dy += val
            of "up":
                dy -= val

    echo(dx * dy)

proc part2() =
    var dx = 0
    var dy = 0
    var aim = 0
    for line in lines("input.txt"):
        let line_seq = line.split({' '})
        let dir = line_seq[0]
        let val = parseInt(line_seq[1])

        case dir:
            of "forward":
                dx += val
                dy += aim * val
            of "down":
                aim += val
            of "up":
                aim -= val

    echo(dx * dy)

part1()
part2()
