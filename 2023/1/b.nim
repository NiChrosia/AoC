import strutils, tables, algorithm, sequtils, strformat

type
    Trie = object
        keys: TableRef[char, Trie]

proc buildTree(words: openArray[string]): Trie =
    result.keys = newTable[char, Trie]()

    for word in words:
        var branch = result

        for c in word:
            if c notin branch.keys:
                branch.keys[c] = Trie(keys: newTable[char, Trie]())

            branch = branch.keys[c]

let text = readFile("input.txt")

let numbers = [
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine"
]

let revNumbers = numbers.mapIt(cast[string](it.reversed()))

var intMap: Table[string, int]
var revIntMap: Table[string, int]

for i in 0 .. 8:
    intMap[numbers[i]] = i + 1
    revIntMap[revNumbers[i]] = i + 1

let letters = buildTree(numbers)
let revLetters = buildTree(revNumbers)

var sum = 0

var branch = letters

var buffer = ""

for line in text.split("\n"):
    branch = letters
    buffer = ""

    echo line

    for c in line:
        if c in '1' .. '9':
            sum += 10 * (ord(c) - ord('0'))
            echo "first number: ", c
            break

        buffer &= $c

        if buffer in intMap:
            sum += 10 * intMap[buffer]
            echo "first number: ", buffer
            break
        elif c in branch.keys:
            branch = branch.keys[c]
        elif c in letters.keys:
            branch = letters.keys[c]
            buffer = $c

    branch = revLetters
    buffer = ""
    
    var i = line.high
    while i > -1:
        let c = line[i]

        if c in '1' .. '9':
            sum += ord(c) - ord('0')
            echo "last number: ", c
            break

        buffer &= $c

        if buffer in revIntMap:
            sum += revIntMap[buffer]
            echo "last number: ", buffer
            break
        elif c in branch.keys:
            branch = branch.keys[c]
        elif c in revLetters.keys:
            branch = revLetters.keys[c]
            buffer = $c

        i -= 1

echo sum
