# Advent of Code 2021 Day 18

from strutils import parseInt

const EXPLODE_THRESHOLD = 3
const SPLIT_THRESHOLD = 9

type Node = ref object
    left: Node
    right: Node
    val: int

proc new_node(v: int): Node =
    var n = new(Node)
    n.val = v
    return n

proc new_node(left: Node, right: Node): Node =
    var n = new(Node)
    n.left = left
    n.right = right
    return n

proc is_leaf(n: Node): bool =
    return n.left == nil

proc is_leaf_pair(n: Node): bool =
    return n.left.is_leaf() and n.right.is_leaf()

proc `$`(n: Node): string =
    if n.is_leaf():
        return $n.val
    else:
        return "[" & $n.left & "," & $n.right & "]"

proc explode_left_helper(left_node: Node, val: int) =
    var curr = left_node
    while not curr.is_leaf():
        curr = curr.right
    curr.val += val

proc explode_right_helper(right_node: Node, val: int) =
    var curr = right_node
    while not curr.is_leaf():
        curr = curr.left
    curr.val += val

proc explode(n: var Node, depth: int, left: Node, right: Node): bool =
    if n.is_leaf():
        return false

    if n.is_leaf_pair():
        if depth > EXPLODE_THRESHOLD:
            let left_val = n.left.val
            let right_val = n.right.val
            if left != nil:
                explode_left_helper(left, left_val)
            if right != nil:
                explode_right_helper(right, right_val)
            n = new_node(0)
            return true
        else:
            return false
    else:
        var exploded = explode(n.left, depth + 1, left, n.right)
        if not exploded:
            exploded = explode(n.right, depth + 1, n.left, right)
        return exploded

proc split_num(n: int): (int, int) =
    if n mod 2 == 0:
        let half = int(n / 2)
        return (half, half)
    else:
        let half = int(n / 2)
        return (half, half + 1)

proc split(n: var Node): bool =
    var splat = false
    if n.is_leaf():
        if n.val > SPLIT_THRESHOLD:
            let (left, right) = split_num(n.val)
            let left_node = new_node(left)
            let right_node = new_node(right)
            n = new_node(left_node, right_node)
            splat = true
    else:
        splat = split(n.left)
        if not splat:
            splat = split(n.right)

    return splat

proc reduce(root: var Node) =
    var again = true
    while again:
        again = false
        var more_exploding = true
        while more_exploding:
            more_exploding = explode(root, 0, nil, nil)
            again = again or more_exploding

        let splited = split(root)
        again = again or splited

proc calc_mag(n: Node): int =
    if n.is_leaf():
        return n.val
    else:
        return 3 * calc_mag(n.left) + 2 * calc_mag(n.right)

proc parse_line(l: string): Node =
    var stack: seq[Node]
    for c in l:
        case c:
            of '[', ',':
                discard
            of ']':
                let right = stack.pop()
                let left = stack.pop()
                let n = new_node(left, right)
                stack.add(n)
            else:
                let v = parseInt($c)
                let n = new_node(v)
                stack.add(n)
    return stack.pop()

proc part1() =
    var root: Node
    for line in lines("test2.txt"):
        var n = parse_line(line)
        if root == nil:
            root = n
        else:
            root = new_node(root, n)
        reduce(root)
    let mag = calc_mag(root)
    echo(mag)

proc part2() =
    var nodes: seq[Node]
    for line in lines("input.txt"):
        let n = parse_line(line)
        nodes.add(n)

    var largest = 0
    for i in 0..<len(nodes):
        for j in 0..<len(nodes):
            if i == j:
                continue
            var nodei, nodej: Node
            deepCopy(nodei, nodes[i])
            deepCopy(nodej, nodes[j])
            var root = new_node(nodei, nodej)
            reduce(root)
            let mag = calc_mag(root)
            if mag > largest:
                largest = mag
    echo(largest)

part1()
part2()
