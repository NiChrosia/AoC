import strutils, sequtils

let input = readFile("./data/1.txt")

var lines = input.split("\n").filterIt(it != "")
var numbers = lines.mapIt(parseInt(it))

var increases = 0

for i in 1 .. numbers.high:
    let previous = numbers[i - 1]
    let current = numbers[i]

    if current > previous:
        increases += 1

echo "increases: " & $increases
