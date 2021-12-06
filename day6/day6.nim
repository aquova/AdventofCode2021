# Advent of Code 2021 Day 6

from math import sum
from strutils import parseInt, split

const POST_NATAL = 6
const NEW_LIFETIME = 8
const MAX_LIFETIME = 9
type Fish = array[MAX_LIFETIME, int]

proc simulate_day(f: var Fish) =
    let zero_cnt = f[0]
    for i in countup(1, NEW_LIFETIME):
        f[i - 1] = f[i]
    f[POST_NATAL] += zero_cnt
    f[NEW_LIFETIME] = zero_cnt

proc day6(num_days: int) =
    var fishes: Fish
    for line in lines("input.txt"):
        let lifetimes = line.split({','})
        for l in lifetimes:
            inc(fishes[parseInt(l)])

    for _ in countup(1, num_days):
        simulate_day(fishes)

    echo(sum(fishes))

day6(80)  # Part 1
day6(256) # Part 2
