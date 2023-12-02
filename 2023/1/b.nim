import strutils, algorithm, sequtils

let nrmNumbers = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
let revNumbers = nrmNumbers.mapIt(cast[string](it.reversed()))

proc buildTrie(words: openArray[string]): seq[int] =
    result.setLen(26)

    for i in 0 .. words.high:
        let word = words[i]
        var pos = 0

        for j in 0 .. word.high - 1:
            let c = word[j]

            if result[pos + ord(c) - ord('a')] == 0:
                let newPos = result.len
                result.setLen(newPos + 26)

                result[pos + ord(c) - ord('a')] = newPos
                pos = newPos
            else:
                pos = result[pos + ord(c) - ord('a')]

        result[pos + ord(word[^1]) - ord('a')] = -i - 1

let text = readFile("input.txt")

let nrmTrie = buildTrie(nrmNumbers)
let revTrie = buildTrie(revNumbers)

var first, last = 0

for line in text.split("\n"):
    block findFirst:
        var i = 0
        while i < line.len:
            let c = line[i]

            if c in '1' .. '9':
                first += int(c)
                break findFirst
            elif nrmTrie[ord(c) - ord('a')] != 0:
                var pos = nrmTrie[ord(c) - ord('a')]
                var buffer = $c

                var j = i + 1
                while j < line.len:
                    let d = line[j]

                    if d notin 'a' .. 'z' or nrmTrie[pos + ord(d) - ord('a')] == 0:
                        break

                    pos = nrmTrie[pos + ord(d) - ord('a')]
                    buffer &= $d

                    if pos < 0:
                        first -= pos
                        break findFirst

                    j += 1
            i += 1

    block findLast:
        var i = line.high
        while i >= 0:
            let c = line[i]

            if c in '1' .. '9':
                last += int(c)
                break findLast
            elif revTrie[ord(c) - ord('a')] != 0:
                var pos = revTrie[ord(c) - ord('a')]
                var buffer = $c

                var j = i - 1
                while j >= 0:
                    let d = line[j]

                    if d notin 'a' .. 'z' or revTrie[pos + ord(d) - ord('a')] == 0:
                        break

                    pos = revTrie[pos + ord(d) - ord('a')]
                    buffer &= $d

                    if pos < 0:
                        last -= pos
                        break findLast

                    j -= 1
            i -= 1

echo first * 10 + last
