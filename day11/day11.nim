# Advent of Code 2021 Day 11

from strutils import split, parseInt
import sequtils

type FlashGrid = seq[seq[int]]

proc flash_spot(g: var FlashGrid, x: int, y: int): bool =
    var another = false

    for dx in -1..1:
        for dy in -1..1:
            let xx = x + dx
            let yy = y + dy
            if xx < 0 or xx == 10 or yy < 0 or yy == 10: continue
            if xx == x and yy == y: continue
            if g[yy][xx] > 0:
                inc(g[yy][xx])
                if g[yy][xx] > 9:
                    another = true
    g[y][x] = 0

    return another

proc flash_step(g: var FlashGrid): int =
    var num_flashes = 0
    let width = len(g[0])
    let height = len(g)

    var flashes_triggered = false
    for row in g.mitems:
        for cell in row.mitems:
            inc(cell)
            flashes_triggered = flashes_triggered or cell > 9

    while flashes_triggered:
        flashes_triggered = false
        for y in 0..<height:
            for x in 0..<width:
                if g[y][x] > 9:
                    if flash_spot(g, x, y):
                        flashes_triggered = true
                    inc(num_flashes)

    return num_flashes

proc all_synced(g: FlashGrid): bool =
    for row in g:
        for cell in row:
            if cell != 0:
                return false
    return true

proc part1() =
    var grid: FlashGrid
    for line in lines("input.txt"):
        let l = line.toSeq().map(proc(x: char): string = $x).map(parseInt)
        grid.add(l)

    var total = 0
    for _ in countup(1, 100):
        total += flash_step(grid)
    echo(total)

proc part2() =
    var grid: FlashGrid
    for line in lines("input.txt"):
        let l = line.toSeq().map(proc(x: char): string = $x).map(parseInt)
        grid.add(l)

    var idx = 0
    while true:
        inc(idx)
        discard flash_step(grid)
        let synced = all_synced(grid)
        if synced:
            echo(idx)
            break

# part1()
part2()
