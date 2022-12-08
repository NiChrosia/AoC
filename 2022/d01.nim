import strutils

let file = readFile("./data/1.txt")

var sums: seq[int]

for chunk in file.split("\n\n"):
    var sum = 0

    for rawNumber in chunk.split("\n"):
        if rawNumber == "":
            continue

        let number = parseInt(rawNumber)
        sum += number

    sums.add(sum)

var topElves: seq[int]
var previousBest = int.high

for i in 0 ..< 3:
    var best = 0

    for sum in sums:
        if sum > best and sum < previousBest:
            best = sum

    topElves.add(best)
    previousBest = best

var total = 0
for elf in topElves:
    total += elf

echo total
