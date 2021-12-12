# Advent of Code 2021 Day 12

import tables
from strutils import split, isLowerAscii

const TARGET = "end"

proc is_lower(s: string): bool =
    for c in s:
        if not isLowerAscii(c):
            return false
    return true

proc dfs(node: string, graph: Table[string, seq[string]], visited: var seq[string], revisited: bool, can_revisit: bool): int =
    if node == TARGET:
        return 1

    var rv = revisited
    if node in visited and node.is_lower():
        rv = true
    visited.add(node)
    let next = graph[node]
    var cnt = 0
    for n in next:
        if n != "start" and (not is_lower(n) or n notin visited or (not rv and can_revisit)):
            cnt += dfs(n, graph, visited, rv, can_revisit)
    discard visited.pop()
    return cnt

proc day12(can_revisit: bool) =
    var nodes = initTable[string, seq[string]]()
    for line in lines("input.txt"):
        # All nodes are bi-directional
        let n = line.split('-')
        if not nodes.hasKey(n[0]):
            nodes[n[0]] = @[]
        if not nodes.hasKey(n[1]):
            nodes[n[1]] = @[]
        nodes[n[0]].add(n[1])
        nodes[n[1]].add(n[0])

    let node = "start"
    var visited: seq[string]
    let cnt = dfs(node, nodes, visited, false, can_revisit)
    echo(cnt)

day12(false) # Part 1
day12(true)  # Part 2
