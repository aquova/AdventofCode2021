# Advent of Code 2021 Day 22

import sets, options, strscans, tables

type Point = tuple
    x: int
    y: int
    z: int

type Cube = object
    on: bool
    x_min: int
    x_max: int
    y_min: int
    y_max: int
    z_min: int
    z_max: int

type CubeCounter = Table[Cube, int]

proc new_cube(off_on: string, x1: int, x2: int, y1: int, y2: int, z1: int, z2: int): Cube =
    let on = off_on == "on"
    return Cube(on: on, x_min: x1, x_max: x2, y_min: y1, y_max: y2, z_min: z1, z_max: z2)

proc volume(c: Cube): int =
    let dx = c.x_max - c.x_min + 1
    let dy = c.y_max - c.y_min + 1
    let dz = c.z_max - c.z_min + 1
    return dx * dy * dz

proc intersect(c1: Cube, c2: Cube): Option[Cube] =
    let on = c2.on
    let x1 = max(c1.x_min, c2.x_min)
    let x2 = min(c1.x_max, c2.x_max)
    let y1 = max(c1.y_min, c2.y_min)
    let y2 = min(c1.y_max, c2.y_max)
    let z1 = max(c1.z_min, c2.z_min)
    let z2 = min(c1.z_max, c2.z_max)
    if x1 <= x2 and y1 <= y2 and z1 <= z2:
        return some(Cube(on: on, x_min: x1, x_max: x2, y_min: y1, y_max: y2, z_min: z1, z_max: z2))
    return none(Cube)

proc add[A, B](tbl: var Table[A, B], val: A, dv: B) =
    if tbl.hasKey(val):
        tbl[val] += dv
    else:
        tbl[val] = dv

proc merge[A, B](tbl: var Table[A, B], other: Table[A, B]) =
    for k, v in other.pairs():
        tbl.add(k, v)

proc part1() =
    var on_pts: HashSet[Point]
    for line in lines("input.txt"):
        let (success, off_on, x1, x2, y1, y2, z1, z2) = scanTuple(line, "$w x=$i..$i,y=$i..$i,z=$i..$i")
        if success:
            if -50 <= x1 and x2 <= 50 and -50 <= y1 and y2 <= 50 and -50 <= z1 and z2 <= 50:
                let c = new_cube(off_on, x1, x2, y1, y2, z1, z2)
                for x in countup(c.x_min, c.x_max):
                    for y in countup(c.y_min, c.y_max):
                        for z in countup(c.z_min, c.z_max):
                            let pt = (x: x, y: y, z: z)
                            if c.on:
                                on_pts.incl(pt)
                            else:
                                on_pts.excl(pt)

    echo(len(on_pts))

proc part2() =
    var cc: CubeCounter
    for line in lines("input.txt"):
        let (success, off_on, x1, x2, y1, y2, z1, z2) = scanTuple(line, "$w x=$i..$i,y=$i..$i,z=$i..$i")
        if success:
            let c = new_cube(off_on, x1, x2, y1, y2, z1, z2)
            var intersections: CubeCounter
            for other, n in cc.pairs():
                let intersection = c.intersect(other)
                if intersection.isSome():
                    let i = intersection.get()
                    intersections.add(i, -n)
            if c.on:
                cc.add(c, 1)
            cc.merge(intersections)

    var total = 0
    for c, cnt in cc.pairs():
        total += cnt * c.volume()
    echo(total)

part1()
part2()

