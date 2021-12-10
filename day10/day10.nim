# Advent of Code 2021 Day 10

import algorithm
import tables

const OPENING_CHARS = ['(', '[', '{', '<']
const MATCHING_CHARS = toTable({'(': ')', '[': ']', '{': '}', '<': '>'})
const CORRUPT_PTS = toTable({')': 3, ']': 57, '}': 1197, '>': 25137})
const INCOMPLETE_PTS = toTable({'(': 1, '[': 2, '{': 3, '<': 4})

proc part1() =
    var pts = 0
    for line in lines("input.txt"):
        var stack: seq[char]
        for c in line:
            if c in OPENING_CHARS:
                stack.add(c)
            else:
                let match = stack.pop()
                if c != MATCHING_CHARS[match]:
                    pts += CORRUPT_PTS[c]
                    break
    echo(pts)

proc part2() =
    var total: seq[int]
    for line in lines("input.txt"):
        var stack: seq[char]
        var corrupt = false
        for c in line:
            if c in OPENING_CHARS:
                stack.add(c)
            else:
                let match = stack.pop()
                if c != MATCHING_CHARS[match]:
                    corrupt = true
                    break
        if len(stack) > 0 and not corrupt:
            var pts = 0
            while len(stack) > 0:
                let c = stack.pop()
                pts = 5 * pts + INCOMPLETE_PTS[c]
            total.add(pts)

    sort(total, SortOrder.Descending)
    let idx = int(len(total) / 2)
    echo(total[idx])

part1()
part2()

