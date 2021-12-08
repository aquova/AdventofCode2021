# Advent of Code 2021 Day 8

from strutils import split

const ONE_DIGITS = 2
const SEVEN_DIGITS = 3
const FOUR_DIGITS = 4
const EIGHT_DIGITS = 7

type DigitArray = array[10, string]

proc find_common(a: string, b: string): string =
    var output = ""
    for letter in a:
        if letter in b:
            output &= letter
    return output

proc is_equivalent(a: string, b: string): bool =
    if len(a) != len(b):
        return false

    for letter in a:
        if letter notin b:
            return false
    return true

proc part1() =
    var total = 0
    for line in lines("input.txt"):
        let digit_output = line.split(" | ")[1]
        let words = digit_output.split(' ')
        for word in words:
            case len(word):
                of ONE_DIGITS, SEVEN_DIGITS, FOUR_DIGITS, EIGHT_DIGITS:
                    inc(total)
                else:
                    discard
    echo(total)

proc part2() =
    var total = 0
    for line in lines("input.txt"):
        var digits: DigitArray
        let input_output = line.split(" | ")
        var unknown_five: seq[string]
        var unknown_six: seq[string]
        # First, go thru and identify the obvious ones
        for word in input_output[0].split(' '):
            case len(word):
                of ONE_DIGITS:
                    digits[1] = word
                of FOUR_DIGITS:
                    digits[4] = word
                of SEVEN_DIGITS:
                    digits[7] = word
                of EIGHT_DIGITS:
                    digits[8] = word
                of 6:
                    unknown_six.add(word)
                else:
                    unknown_five.add(word)

        # Identify the 6-segment ones
        for word in unknown_six:
            let diff_four = find_common(word, digits[4])
            if len(diff_four) == 4:
                digits[9] = word
            else:
                let diff_one = find_common(word, digits[1])
                if len(diff_one) == 1:
                    digits[6] = word
                else:
                    digits[0] = word

        # Identify the 5-segment ones
        for word in unknown_five:
            let six_diff = find_common(word, digits[6])
            if len(six_diff) == 5:
                digits[5] = word
            else:
                let one_diff = find_common(word, digits[1])
                if len(one_diff) == 1:
                    digits[2] = word
                else:
                    digits[3] = word

        # Time for the outputs!
        var value = 0
        for word in input_output[1].split(' '):
            for i in countup(0, 9):
                if is_equivalent(word, digits[i]):
                    value = (10 * value) + i
                    break
        total += value
    echo(total)

part1()
part2()

