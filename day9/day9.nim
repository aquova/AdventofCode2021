# Advent of Code 2021 Day 9

import algorithm
from strutils import parseInt, split
import sequtils

type HeightMap = seq[seq[int]]

proc part1() =
    var hm: HeightMap
    for line in lines("input.txt"):
        let l = line.toSeq().map(proc(x: char): string = $x).map(parseInt)
        hm.add(l)
    let width = len(hm[0])
    let height = len(hm)

    var risks = 0
    for y in 0..<height:
        for x in 0..<width:
            let v = hm[y][x]
            if x > 0 and hm[y][x - 1] <= v: continue
            if x < width - 1 and hm[y][x + 1] <= v: continue
            if y > 0 and hm[y - 1][x] <= v: continue
            if y < height - 1 and hm[y + 1][x] <= v: continue
            risks += v + 1
    echo(risks)

proc flood_fill(m: var HeightMap, x: int, y: int): int =
    if x < 0 or x == len(m[0]) or y < 0 or y == len(m):
        return 0
    if m[y][x] == 9:
        return 0

    m[y][x] = 9
    var cnt = 1
    cnt += flood_fill(m, x + 1, y)
    cnt += flood_fill(m, x - 1, y)
    cnt += flood_fill(m, x, y + 1)
    cnt += flood_fill(m, x, y - 1)
    return cnt

proc part2() =
    var hm: HeightMap
    for line in lines("input.txt"):
        let l = line.toSeq().map(proc(x: char): string = $x).map(parseInt)
        hm.add(l)

    var basins: seq[int]
    let width = len(hm[0])
    let height = len(hm)
    for y in 0..<height:
        for x in 0..<width:
            if hm[y][x] != 9:
                let nb = flood_fill(hm, x, y)
                basins.add(nb)

    sort(basins, SortOrder.Descending)
    var prod = 1
    for i in countup(0, 2):
        prod *= basins[i]
    echo(prod)

part1()
part2()
