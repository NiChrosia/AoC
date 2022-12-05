import strutils

type
    Line = object
        left, right: int

proc contains(a: Line, b: int): bool =
    return b >= a.left and b <= a.right

proc intersects(a, b: Line): bool =
    return a.contains(b.left) or a.contains(b.right)

proc contains(a, b: Line): bool =
    return a.contains(b.left) and a.contains(b.right)

proc line(raw: string): Line =
    let parts = raw.split("-")

    result.left = parts[0].parseInt()
    result.right = parts[1].parseInt()

proc a(input: string): int =
  for line in input.split("\n"):
    if line == "":
        continue

    let pair = line.split(",")

    let a = pair[0].line()
    let b = pair[1].line()

    if a.contains(b) or b.contains(a):
        result += 1

proc b(input: string): int =
  for line in input.split("\n"):
    if line == "":
        continue

    let pair = line.split(",")

    let a = pair[0].line()
    let b = pair[1].line()
    
    if a.intersects(b) or b.intersects(a):
        result += 1

let input = readFile("./data/4.txt")

when defined(a):
    echo a(input)
else:
    echo b(input)
