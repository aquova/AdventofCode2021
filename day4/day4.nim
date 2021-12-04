# Advent of Code 2021 Day 4

from strutils import parseInt, split, splitWhitespace

const CARD_SIZE = 5
type BingoCard = object
    nums: array[CARD_SIZE, array[CARD_SIZE, int]]
    hits: array[CARD_SIZE, array[CARD_SIZE, bool]]

proc populate_card(c: var BingoCard, nums: seq[int]) =
    for i, n in nums:
        let x = i mod CARD_SIZE
        let y = int(i / CARD_SIZE)
        c.nums[y][x] = n

# Debugging function
proc echo_table(c: BingoCard) =
    for y in 0..<CARD_SIZE:
        var row_str = ""
        for x in 0..<CARD_SIZE:
            row_str = row_str & "[" & $c.nums[y][x] & " " & $c.hits[y][x] & "]"
        echo(row_str)
    echo("")

proc is_bingo(c: BingoCard): bool =
    # Check all vertical
    for x in 0..<CARD_SIZE:
        var hits = true
        for y in 0..<CARD_SIZE:
            let hit = c.hits[y][x]
            hits = hits and hit
        if hits: return true

    # Check all horizontal
    for y in 0..<CARD_SIZE:
        var hits = true
        for x in 0..<CARD_SIZE:
            let hit = c.hits[y][x]
            hits = hits and hit
        if hits: return true

    return false

proc mark_card(c: var BingoCard, val: int): bool =
    for y, row in c.nums:
        for x, n in row:
            if n == val:
                c.hits[y][x] = true
                return is_bingo(c)

proc calc_unmarked_sum(c: BingoCard): int =
    var sum = 0
    for y in 0..<CARD_SIZE:
        for x in 0..<CARD_SIZE:
            if not c.hits[y][x]:
                sum += c.nums[y][x]
    return sum

proc day4(trying_to_lose: bool) =
    var
        f: File
        bingo_nums: seq[int]
        line: string
        bingo_cards: seq[BingoCard]
        curr_tbl: seq[int]

    if open(f, "input.txt"):
        # First, read in our bingo numbers
        discard f.readLine(line)
        let raw_seq = line.split({','})
        for v in raw_seq:
            let num = parseInt(v)
            bingo_nums.add(num)

        # Skip blank line
        discard f.readLine(line)
        # Now read in all the bingo tables
        while f.readLine(line):
            if line == "":
                var new_card = BingoCard()
                populate_card(new_card, curr_tbl)
                bingo_cards.add(new_card)
                curr_tbl = @[]
            else:
                let raw = line.splitWhitespace
                for v in raw:
                    let num = parseInt(v)
                    curr_tbl.add(num)

    # Save off the last one
    if len(curr_tbl) > 0:
        var new_card = BingoCard()
        populate_card(new_card, curr_tbl)
        bingo_cards.add(new_card)
    close(f)

    for num in bingo_nums:
        var losing_seq: seq[BingoCard]
        for card in bingo_cards.mitems:
            let is_bingo = mark_card(card, num)
            if is_bingo:
                if len(bingo_cards) == 1 or not trying_to_lose:
                    let sum = calc_unmarked_sum(card)
                    echo (num * sum)
                    return
            else:
                losing_seq.add(card)
        bingo_cards = losing_seq
    echo("Uh... never found a bingo")

day4(false) # Part 1
day4(true)  # Part 2
