import strutils

proc run*(text: string): int =
    var first = 0
    var last = 0

    for line in text.split("\n"):
      for c in line:
        if int(c) <= int('9'):
          first += int(c) - int('0')
          break

      for i in countdown(line.high, 0):
        if int(line[i]) <= int('9'):
          last += int(line[i]) - int('0')
          break

    return first * 10 + last
