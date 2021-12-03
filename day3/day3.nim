# Advent of Code 2021 Day 3

from strutils import parseInt, fromBin

# So much for making this generic to any input
const INPUT_BITS = 12
type BitBin = array[INPUT_BITS, int]

# Foward declare
proc prune_by_bit(input: seq[uint], most_common: bool, bit_idx: int): seq[uint]

proc part1() =
    var bins: BitBin
    var num = 0
    for line in lines("input.txt"):
        let val = fromBin[uint16](line)
        inc(num)
        for i in countup(0, INPUT_BITS - 1):
            let mask = 1'u16 shl i
            let bit = val and mask
            if bit > 0:
                inc(bins[INPUT_BITS - i - 1])

    var gamma = 0'u
    let target = int(num / 2)
    for i in countup(0, INPUT_BITS - 1):
        let bitsum = bins[INPUT_BITS - i - 1]
        if bitsum >= target:
            gamma = gamma or (1'u shl i)

    # Need to remove higher bits from the inverse
    let e_mask = (1'u shl INPUT_BITS) - 1
    let epsilon = ((not gamma) and e_mask)
    echo(gamma * epsilon)

proc part2() =
    # Read data into sequence
    var input: seq[uint]
    for line in lines("input.txt"):
        let val = fromBin[uint](line)
        input.add(val)

    var most_common = input
    var least_common = input
    for bit_idx in countdown(INPUT_BITS - 1, 0):
        most_common = prune_by_bit(most_common, true, bit_idx)
        least_common = prune_by_bit(least_common, false, bit_idx)

    echo(most_common[0] * least_common[0])

proc prune_by_bit(input: seq[uint], most_common: bool, bit_idx: int): seq[uint] =
    if len(input) == 1:
        return input

    var ones_seq: seq[uint]
    var zeroes_seq: seq[uint]
    let mask = 1'u shl bit_idx

    for v in input:
        let bit = v and mask
        if bit > 0:
            ones_seq.add(v)
        else:
            zeroes_seq.add(v)

    if most_common:
        if len(ones_seq) >= len(zeroes_seq):
            return ones_seq
        else:
            return zeroes_seq
    else:
        if len(zeroes_seq) <= len(ones_seq):
            return zeroes_seq
        else:
            return ones_seq

part1()
part2()

