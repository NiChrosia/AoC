import strutils, tables, algorithm, sequtils

type
    Trie = object
        keys: TableRef[char, Trie]

proc buildTrie(words: openArray[string]): Trie =
    result.keys = newTable[char, Trie]()

    for word in words:
        var branch = result

        for c in word:
            if c notin branch.keys:
                branch.keys[c] = Trie(keys: newTable[char, Trie]())

            branch = branch.keys[c]

let text = readFile("input.txt")

let nrmNumbers = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
let revNumbers = nrmNumbers.mapIt(cast[string](it.reversed()))

let nrmIntMap = toTable(zip(nrmNumbers, toSeq(1 .. 9)))
let revIntMap = toTable(zip(revNumbers, toSeq(1 .. 9)))

let nrmTrie = buildTrie(nrmNumbers)
let revTrie = buildTrie(revNumbers)

var sum = 0

proc processChar(
    multiplier: int,
    intMap: Table[string, int],
    numTrie: Trie,
    branches: var seq[Trie],
    buffers: var seq[string],
    sum: var int,
    c: char
): bool {.inline.} =
    if c in '1' .. '9':
        sum += multiplier * (ord(c) - ord('0'))
        return true

    if c in numTrie.keys:
        branches.add(numTrie)
        buffers.add("")

    var i = 0
    while i < branches.len:
        buffers[i] &= $c

        if buffers[i] in intMap:
            sum += multiplier * intMap[buffers[i]]
            return true
        elif c in branches[i].keys:
            branches[i] = branches[i].keys[c]
        else:
            branches.delete(i)
            buffers.delete(i)
            continue

        i += 1

for line in text.split("\n"):
    var branches: seq[Trie]
    var buffers: seq[string]

    for c in line:
        if processChar(10, nrmIntMap, nrmTrie, branches, buffers, sum, c):
            break

    branches = @[]
    buffers = @[]
    
    for i in countdown(line.high, 0):
        if processChar(1, revIntMap, revTrie, branches, buffers, sum, line[i]):
            break

echo sum
