import strutils, sequtils

proc priority(c: char): int =
    if c in 'a' .. 'z':
        return ord(c) - ord('a') + 1
    elif c in 'A' .. 'Z':
        return ord(c) - ord('A') + 27

assert 'a'.priority == 1
assert 'z'.priority == 26
assert 'A'.priority == 27
assert 'Z'.priority == 52

proc intersection(sets: seq[string]): int =
    var priorities: array[1 .. 52, int]

    for set in sets:
        var encountered: array[1 .. 52, int]

        for c in set:
            encountered[c.priority] = 1

        for i in 1 .. 52:
            priorities[i] += encountered[i]

            if priorities[i] == sets.len:
                return i

proc a(input: string): int =
    for line in input.split("\n"):
        if line == "":
            continue

        var sets = @[line[0 .. line.high div 2], line[(line.high div 2) + 1 .. line.high]]
        result += sets.intersection()

proc b(input: string): int =
    var lines: seq[string]

    for line in input.split("\n"):
        lines.add(line)

        if lines.len == 3:
            result += lines.intersection()

            lines = @[]

let data = readFile("./data/3.txt")
let result = when defined(a):
    a(data)
else:
    b(data)

echo result
