# Advent of Code 2021 Day 16

from strutils import fromBin, fromHex, join, stripLineEnd, toBin
from math import prod, sum

const PADDING = 8
const LITERAL_ID = 4

const VERSION_LEN = 3
const ID_LEN = 3

const LITERAL_LEN = 4

const SUBPACKET_LEN_LEN = 15
const SUBPACKET_NUM_LEN = 11

# Forward declare
proc parse(b: string, idx: var int, end_idx: int, want_version: bool): seq[int]

proc process_literals(vals: seq[int], op: int): int =
    var output: int
    case op:
        of 0:
            output = sum(vals)
        of 1:
            output = prod(vals)
        of 2:
            output = min(vals)
        of 3:
            output = max(vals)
        of 5:
            output = if vals[0] > vals[1]: 1 else: 0
        of 6:
            output = if vals[0] < vals[1]: 1 else: 0
        of 7:
            output = if vals[0] == vals[1]: 1 else: 0
        else:
            assert(true)
    return output

proc parse_literal(b: string, idx: var int, want_version: bool): int =
    var last = false
    var output = 0
    while not last:
        if b[idx] == '0':
            last = true
        inc(idx)
        let v = fromBin[int](b[idx..<(idx + LITERAL_LEN)])
        output = (output shl 4) or v
        idx += LITERAL_LEN

    if want_version:
        return 0
    else:
        return output

proc parse_ops(b: string, idx: var int, op: int, want_version: bool): int =
    var output: int
    var literals: seq[int]
    let len_type = b[idx]
    inc(idx)

    if len_type == '0':
        let sub_packet_len = fromBin[int](b[idx..<(idx + SUBPACKET_LEN_LEN)])
        idx += SUBPACKET_LEN_LEN
        let l = parse(b, idx, idx + sub_packet_len, want_version)
        literals = l
    else:
        let sub_packet_num = fromBin[int](b[idx..<(idx + SUBPACKET_NUM_LEN)])
        idx += SUBPACKET_NUM_LEN
        for i in countup(1, sub_packet_num):
            let l = parse(b, idx, idx + PADDING + 1, want_version)
            literals &= l

    if want_version:
        output = sum(literals)
    else:
        output = process_literals(literals, op)

    return output

proc parse(b: string, idx: var int, end_idx: int, want_version: bool): seq[int] =
    var output: seq[int]
    while (idx + PADDING) < end_idx:
        let version = fromBin[int](b[idx..<(idx + VERSION_LEN)])
        idx += VERSION_LEN
        let id = fromBin[int](b[idx..<(idx + ID_LEN)])
        idx += ID_LEN

        let val = case id:
            of LITERAL_ID:
                parse_literal(b, idx, want_version)
            else:
                parse_ops(b, idx, id, want_version)
        if want_version:
            output.add(version + val)
        else:
            output.add(val)

    return output

proc day16(want_version: bool) =
    var
        f: File
        bytes = ""

    if not open(f, "input.txt"):
        echo("Unable to open file")
        return

    let raw = f.readLine()
    close(f)

    for c in raw:
        let n = fromHex[int]($c)
        bytes &= n.toBin(4)

    var idx = 0
    let v = parse(bytes, idx, len(bytes), want_version)
    echo(v[0])

day16(true)  # Part 1
day16(false) # Part 2
