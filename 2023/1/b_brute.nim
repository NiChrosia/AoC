import strutils

let input = readFile("input.txt")

let numbers = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

var first = 0
var last = 0

for line in input.split("\n"):
    var mutLine = line

    block findFirst:
        while mutLine.len > 0:
            if int(mutLine[0]) <= int('9'):
                first += int(mutLine[0]) - int('0')
                break findFirst

            for i in 0 .. numbers.high:
                if mutLine.startsWith(numbers[i]):
                    first += i + 1
                    break findFirst

            mutLine = mutLine[1 .. ^1]

    mutLine = line

    block findLast:
        while mutLine.len > 0:
            if int(mutLine[^1]) <= int('9'):
                last += int(mutLine[^1]) - int('0')
                break findLast

            for i in 0 .. numbers.high:
                if mutLine.endsWith(numbers[i]):
                    last += i + 1
                    break findLast

            mutLine = mutLine[0 .. ^2]

echo first * 10 + last
