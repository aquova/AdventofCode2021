# Advent of Code 2021 Day 20

import sequtils

type Image = seq[seq[bool]]

proc echo_img(img: Image) =
    for row in img:
        var s = ""
        for v in row:
            let b = if v: "#" else: "."
            s &= b
        echo(s)

proc expand_img(img: Image, size: int): Image =
    var output: Image
    let width = len(img[0])
    let border = @[false].cycle(width + 2 * size)
    for _ in countup(1, size):
        output.add(border)

    let edge = @[false].cycle(size)
    for l in img:
        let n = concat(edge, l, edge)
        output.add(n)

    for _ in countup(1, size):
        output.add(border)

    return output

proc calc_next(img: Image, reference: string, x: int, y: int, infinite_lit: bool): bool =
    var idx = 0
    let flip_infinite = (reference[0] == '#')
    for yy in countup(-1, 1):
        for xx in countup(-1, 1):
            var b = 0
            let ix = x + xx
            let iy = y + yy
            if ix < 0 or iy < 0 or iy == len(img) or ix == len(img[0]):
                b = if infinite_lit and flip_infinite: 1 else: 0
            else:
                let v = img[y + yy][x + xx]
                b = if v: 1 else: 0
            idx = (idx shl 1) or b
    return reference[idx] == '#'

proc enhance(img: Image, reference: string, infinite_lit: bool): Image =
    let height = len(img) - 1
    let width = len(img[0]) - 1

    var output = deepCopy(img)
    for y in countup(0, width):
        for x in countup(0, height):
            output[y][x] = calc_next(img, reference, x, y, infinite_lit)

    return output

proc count_lit(img: Image): int =
    var cnt = 0
    let width = len(img[0])
    let height = len(img)
    for y in countup(2, width - 3):
        for x in countup(2, height - 3):
            if img[y][x]: inc(cnt)
    return cnt

proc day20(n: int) =
    var
        f: File
        line: string
        enhancement: string
        img: Image

    if not open(f, "input.txt"):
        echo("Unable to open file")
        return

    discard f.readLine(enhancement)
    discard f.readLine(line)

    while not f.endOfFile():
        var l: seq[bool]
        discard f.readLine(line)
        for c in line:
            let v = if c == '#': true else: false
            l.add(v)
        img.add(l)

    img = expand_img(img, 2 * n)
    var infinite_lit = false
    for _ in countup(1, n):
        img = enhance(img, enhancement, infinite_lit)
        infinite_lit = not infinite_lit
    # echo_img(img)
    echo(count_lit(img))

day20(2)  # Part 1
day20(50) # Part 2
