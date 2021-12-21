# Advent of Code 2021 Day 21

import strscans

const P1_GOAL = 1000
const P2_GOAL = 21

# (dice roll, number of possible outcomes of that roll)
const P2_ODDS = [(3, 1), (4, 3), (5, 6), (6, 7), (7, 6), (8, 3), (9, 1)]

proc part1() =
    var
        pos: seq[int]
        turn = 0
        scores = @[0, 0]
        dice = 0
        rolls = 0

    for line in lines("input.txt"):
        let (success, _, p) = scanTuple(line, "Player $i starting position: $i")
        if success:
            pos.add(p - 1)

    while true:
        for _ in countup(1, 3):
            pos[turn] = (pos[turn] + dice + 1) mod 10
            dice = (dice + 1) mod 100
            inc(rolls)
        scores[turn] += pos[turn] + 1
        if scores[turn] >= P1_GOAL:
            break
        turn = (turn + 1) mod 2

    turn = (turn + 1) mod 2
    echo(rolls * scores[turn])

proc p2_helper(p1_turn: bool, p1: int, p2: int, p1_score: int, p2_score: int, roll: int): int =
    var p1_next = p1
    var p2_next = p2
    var p1_s = p1_score
    var p2_s = p2_score
    if p1_turn:
        p1_next = (p1_next + roll) mod 10
        p1_s += p1_next + 1
        if p1_s >= P2_GOAL:
            return 1
    else:
        p2_next = (p2_next + roll) mod 10
        p2_s += p2_next + 1
        if p2_s >= P2_GOAL:
            return 0

    var n = 0
    for (roll, occur) in P2_ODDS:
        n += occur * p2_helper(not p1_turn, p1_next, p2_next, p1_s, p2_s, roll)

    return n

proc part2() =
    var pos: seq[int]

    for line in lines("input.txt"):
        let (success, _, p) = scanTuple(line, "Player $i starting position: $i")
        if success:
            pos.add(p - 1)

    var wins = 0
    for (roll, occur) in P2_ODDS:
        wins += occur * p2_helper(true, pos[0], pos[1], 0, 0, roll)
    echo(wins)

part1()
part2()
