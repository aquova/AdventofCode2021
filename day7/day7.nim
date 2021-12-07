# Advent of Code 2021 Day 7

from strutils import parseInt, split
import sequtils

proc part1() =
    var
        f: File
        line: string
    if not open(f, "input.txt"):
        echo("Unable to open file")
        return

    discard f.readLine(line)
    close(f)
    let x_pos = line.split(',').map(parseInt)
    var best = 999999
    var target_x = min(x_pos)
    while true:
        var total_dx = 0
        for x in x_pos:
            total_dx += abs(x - target_x)
        if total_dx > best:
            echo(best)
            return
        else:
            best = total_dx
            inc(target_x)

proc part2_fuel(dx: int): int =
    var fuel = 0
    for i in countup(1, dx):
        fuel += i
    return fuel

proc part2() =
    var
        f: File
        line: string
    if not open(f, "input.txt"):
        echo("Unable to open file")
        return

    discard f.readLine(line)
    close(f)

    let x_pos = line.split(',').map(parseInt)
    var best = 999999999
    var target_x = min(x_pos)
    while true:
        var total_dx = 0
        for x in x_pos:
            total_dx += part2_fuel(abs(x - target_x))
        if total_dx > best:
            echo(best)
            return
        else:
            best = total_dx
            inc(target_x)

part1()
part2()
