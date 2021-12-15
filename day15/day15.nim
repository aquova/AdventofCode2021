# Advent of Code 2021 Day 15

import heapqueue, sequtils
from strutils import parseInt

const BIG_NUM = 9999
type Grid = seq[seq[int]]
type Distances = seq[seq[int]]

type Entry = tuple
    dst: int
    x: int
    y: int

proc `<`(a, b: Entry): bool =
    a.dst < b.dst

proc day15(tile_scale: int) =
    var grid: Grid
    var distances: Distances
    for line in lines("input.txt"):
        let l = line.toSeq().map(proc(c: char): string = $c).map(parseInt)
        grid.add(l)

    let width = len(grid[0])
    let height = len(grid)
    let max_x = tile_scale * width
    let max_y = tile_scale * height

    # I couldn't find a better way to populate a seq than this..
    for y in countup(1, max_y):
        var row: seq[int]
        for x in countup(1, max_x):
            row.add(BIG_NUM)
        distances.add(row)

    var q = initHeapQueue[Entry]()
    let start = (dst: 0, x: 0, y: 0)
    q.push(start)

    while len(q) > 0:
        let e = q.pop()
        if e.x < 0 or e.y < 0 or e.x == max_x or e.y == max_y:
            continue

        if distances[e.y][e.x] != BIG_NUM:
            continue

        var offset = 0
        var x = e.x mod width
        offset += int(e.x / width)
        var y = e.y mod height
        offset += int(e.y / height)

        let enhanced = grid[y][x] + offset
        var modified = enhanced mod 10
        modified += int(enhanced / 10)
        let value = e.dst + modified
        distances[e.y][e.x] = value
        if e.x == max_x - 1 and e.y == max_y - 1:
            break

        q.push((dst: value, x: e.x - 1, y: e.y))
        q.push((dst: value, x: e.x + 1, y: e.y))
        q.push((dst: value, x: e.x, y: e.y - 1))
        q.push((dst: value, x: e.x, y: e.y + 1))

    let final = distances[max_y - 1][max_x - 1]
    echo(final - distances[0][0])

day15(1) # Part 1
day15(5) # Part 2
