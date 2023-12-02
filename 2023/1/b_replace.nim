import strutils

proc run*(text: string): int =
    var sum = 0

    for line in text.split("\n"):
        let replaced = line
            .replace("one", "o1e")
            .replace("two", "t2o")
            .replace("three", "t3e")
            .replace("four", "4")
            .replace("five", "5e")
            .replace("six", "6")
            .replace("seven", "7n")
            .replace("eight", "e8")
            .replace("nine", "n9e")

        for c in replaced:
            if c in '1' .. '9':
                sum += 10 * (ord(c) - ord('0'))
                break

        for i in countdown(replaced.high, 0):
            if replaced[i] in '1' .. '9':
                sum += ord(replaced[i]) - ord('0')
                break

    return sum
