# Advent of Code 2021 Day 19

import math, sets, strscans, tables

const BEACON_THRESHOLD = 11

type Point = tuple
    x: int
    y: int
    z: int

type Scanner = seq[Point]
type Distance = HashSet[int]
type MatchingPts = Table[Point, seq[Point]]

proc dst(p1: Point, p2: Point): int =
    let dx = abs(p1.x - p2.x)
    let dy = abs(p1.y - p2.y)
    let dz = abs(p1.z - p2.z)
    let dst = (dx ^ 2) + (dy ^ 2) + (dz ^ 2)
    return dst

proc fetch_common(matches: var HashSet[Point], tbl: MatchingPts, curr: Point) =
    if curr in matches:
        return

    matches.incl(curr)
    for v in tbl[curr]:
        fetch_common(matches, tbl, v)

proc part1() =
    # Parsing
    var total_cnt = 0
    var scanners: seq[Scanner]
    var scanner: Scanner
    for line in lines("input.txt"):
        let (success, x, y, z) = scanTuple(line, "$i,$i,$i")
        if success:
            let p = (x: x, y: y, z: z)
            inc(total_cnt)
            scanner.add(p)
        elif len(scanner) > 0:
            scanners.add(scanner)
            scanner = @[]
    scanners.add(scanner)

    # Generating distances from a point to all other points in scanner
    var distances: seq[seq[Distance]]
    for group in scanners:
        var dpt: seq[Distance]
        for i in 0..<len(group):
            var d: Distance
            for j in 0..<len(group):
                if i == j:
                    continue
                d.incl(dst(group[i], group[j]))
            dpt.add(d)
        distances.add(dpt)

    # The idea: if there are 12 points in any group where the distances to each other
    # match the distances to another group of 12, then they must be the same points
    # We'll save off equal points for later comparison
    var tbl: MatchingPts
    for i in 0..<(len(distances) - 1):
        for j in (i + 1)..<(len(distances)):
            for a, da in distances[i]:
                for b, db in distances[j]:
                    let inter = da * db
                    if len(inter) > 2:
                    # if len(inter) == BEACON_THRESHOLD:
                        let pa = scanners[i][a]
                        let pb = scanners[j][b]

                        if tbl.hasKey(pa):
                            tbl[pa].add(pb)
                        else:
                            tbl[pa] = @[pb]

                        if tbl.hasKey(pb):
                            tbl[pb].add(pa)
                        else:
                            tbl[pb] = @[pa]
                        break

    # Now that we know which points are actually the same, we need to account for ones that are in >2 groups
    var seen = initHashSet[Point]()
    for k, v in tbl:
        if k in seen:
            continue
        var match_set = initHashSet[Point]()
        fetch_common(match_set, tbl, k)
        total_cnt -= (len(match_set) - 1)
        seen = seen + match_set

    echo(total_cnt)

part1()
