# Advent of Code 2021 Day 14

import strscans, tables

proc polymerization(polymers: Table[string, char], counts: CountTable[string], chars: var CountTable[char]): CountTable[string] =
    var new_tbl = initCountTable[string]()
    for k, v in counts.pairs():
        let middle = polymers[k]
        let left = k[0] & middle
        let right = middle & k[1]

        chars.inc(middle, v)
        new_tbl.inc(left, v)
        new_tbl.inc(right, v)

    return new_tbl

proc part1(num: int) =
    var
        f: File
        line: string
        start: string

    if not open(f, "input.txt"):
        echo("Unable to open file")
        return

    # Read in the polymer template
    discard f.readLine(start)
    discard f.readLine(line)

    var polymers = initTable[string, char]()
    while f.readLine(line):
        let (success, before, after) = scanTuple(line, "$w -> $c")
        if success:
            polymers[before] = after

    close(f)

    # Populate start to begin
    var polymer_count = initCountTable[string]()
    for i in countup(0, len(start) - 2):
        let substring = start[i .. i + 1]
        polymer_count[substring] = 1

    var cnt_tbl = initCountTable[char]()
    for c in start:
        cnt_tbl.inc(c)

    for _ in countup(1, num):
        polymer_count = polymerization(polymers, polymer_count, cnt_tbl)

    let (largest_str, largest_v) = cnt_tbl.largest()
    let (smallest_str, smallest_v) = cnt_tbl.smallest()
    echo(largest_v - smallest_v)

day14(10) # Part 1
day14(40) # Part 2
