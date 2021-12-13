# Advent of Code 2021 Day 13

import sets, strscans

type AsciiOutput = array[6, array[40, bool]]

type Direction = enum
    vertical, horizontal

type Point = tuple
    x: int
    y: int

type Fold = tuple
    dir: Direction
    line: int

proc fold_points(points: HashSet[Point], fold: Fold): HashSet[Point] =
    var new_set = initHashSet[Point]()
    for p in points:
        if fold.dir == vertical and p.y > fold.line:
            let new_y = fold.line - (p.y - fold.line)
            let pt = (x: p.x, y: new_y)
            new_set.incl(pt)
        elif fold.dir == horizontal and p.x > fold.line:
            let new_x = fold.line - (p.x - fold.line)
            let pt = (x: new_x, y: p.y)
            new_set.incl(pt)
        else:
            new_set.incl(p)
    return new_set

proc echo_points(points: HashSet[Point]) =
    var graph: AsciiOutput
    for p in points:
        graph[p.y][p.x] = true

    for row in graph:
        var str = ""
        for x in row:
            let c = if x: "X" else: " "
            str &= c
        echo(str)

proc day13() =
    var pts = initHashSet[Point]()
    var folds: seq[Fold]
    var scanning_pts = true
    for line in lines("input.txt"):
        if line == "":
            scanning_pts = false
            continue

        if scanning_pts:
            let (success, x, y) = scanTuple(line, "$i,$i")
            if success:
                let new_pt = (x: x, y: y)
                pts.incl(new_pt)
        else:
            let (success, dir, l) = scanTuple(line, "fold along $c=$i")
            if success:
                let d = if dir == 'x': horizontal else: vertical
                let f = (dir: d, line: l)
                folds.add(f)

    var part1 = true
    for fold in folds:
        pts = fold_points(pts, fold)
        if part1:
            echo(len(pts))
            part1 = false
    echo_points(pts)

day13()
