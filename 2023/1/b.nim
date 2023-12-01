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

var first, last = 0

for line in text.split("\n"):
    block findFirst:
        var i = 0
        while i < line.len:
            let c = line[i]

            if c in '1' .. '9':
                first += ord(c) - ord('0')
                break findFirst
            elif c in nrmTrie.keys:
                var branch = nrmTrie.keys[c]
                var buffer = $c

                var j = i + 1
                while j < line.len:
                    let d = line[j]

                    if d notin branch.keys:
                        break

                    branch = branch.keys[d]
                    buffer &= $d

                    if branch.keys.len == 0:
                        first += nrmIntMap[buffer]
                        break findFirst

                    j += 1
            i += 1

    block findLast:
        var i = line.high
        while i >= 0:
            let c = line[i]

            if c in '1' .. '9':
                last += ord(c) - ord('0')
                break findLast
            elif c in revTrie.keys:
                var branch = revTrie.keys[c]
                var buffer = $c

                var j = i - 1
                while j >= 0:
                    let d = line[j]

                    if d notin branch.keys:
                        break

                    branch = branch.keys[d]
                    buffer &= $d

                    if branch.keys.len == 0:
                        last += revIntMap[buffer]
                        break findLast

                    j -= 1
            i -= 1

echo first * 10 + last
