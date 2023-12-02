import strutils

let input = readFile("input.txt")

let numbers = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

var first = 0
var last = 0

for line in input.split("\n"):
    block findFirst:
        var lineIndex = -1
        var lineAddr: ptr char
        var lineArr: array[100, char]

        while lineIndex < line.high:
            lineIndex += 1
            lineAddr = addr line[lineIndex]
            lineArr = cast[array[100, char]](lineAddr)

            if int(lineArr[0]) <= int('9'):
                first += int(lineArr[0]) - int('0')
                break findFirst

            for i in 0 .. numbers.high:
                if numbers[i].len > line.high - lineIndex:
                    continue

                var starts = true
                for j in 0 .. numbers[i].high:
                    if lineArr[j] != numbers[i][j]:
                        starts = false
                        break

                if starts:
                    first += i + 1
                    break findFirst

    var mutLine = line

    block findLast:
        while mutLine.len > 0:
            if int(mutLine[^1]) <= int('9'):
                last += int(mutLine[^1]) - int('0')
                break findLast

            for i in 0 .. numbers.high:
                if mutLine.endsWith(numbers[i]):
                    last += i + 1
                    break findLast

            mutLine.setLen(mutLine.len - 1)

echo first * 10 + last
