# Advent of Code 2021 Day 17

import strscans
from math import sgn

const BIG_NUM = 999

type Pos = object
    x: int
    y: int
    dx: int
    dy: int
    max_hght: int

type Rect = tuple
    x1: int
    y1: int
    x2: int
    y2: int

proc contains(t: Rect, p: Pos): bool =
    return t.x1 <= p.x and p.x <= t.x2 and p.y <= t.y1 and t.y2 <= p.y

proc day17() =
    var target: Rect
    for line in lines("input.txt"):
        let (success, x1, x2, y1, y2) = scanTuple(line, "target area: x=$i..$i, y=$i..$i")
        if success:
            target = (x1: x1, y1: y2, x2: x2, y2: y1)

    var max_hght = 0
    var cnt = 0
    for init_dx in 0..target.x2:
        for init_dy in target.y2..BIG_NUM:
            var pos = Pos(x: 0, y: 0, dx: init_dx, dy: init_dy, max_hght: 0)
            while pos.x < target.x2 and pos.y > target.y2:
                pos.x += pos.dx
                pos.y += pos.dy
                pos.dx -= sgn(pos.dx)
                pos.dy -= 1
                if pos.y > pos.max_hght:
                    pos.max_hght = pos.y

                if target.contains(pos):
                    if pos.max_hght > max_hght:
                        max_hght = pos.max_hght
                    inc(cnt)
                    break
    echo(max_hght)
    echo(cnt)

day17()

