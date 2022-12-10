import strutils, sequtils

let input = readFile("data/8.txt")
let rows = input.split("\n").mapIt(it.replace("\r", "")).filterIt(it != "")

let width = rows[0].len
let height = rows.len

proc digit(x, y: int): int =
    if x < 0 or x >= width or y < 0 or y >= height:
        return 0

    rows[y][x].ord() - '0'.ord()

proc set[T](a: var openArray[T], s: Slice[int], v: T) =
    for i in s:
        a[i] = v

proc inc[T](a: var openArray[T], s: Slice[int], v: T) =
    for i in s:
        a[i] += v

# left, right, up, down
var visibilities = newSeqWith(4, newSeqWith(height, newSeq[int](width)))

var visibleTrees = 0
var bestScenicScore = -1

for y in 0 ..< height:
    var viewsByHeight: array[0 .. 9, int]

    for x in 0 ..< width:
        let digit = digit(x, y)

        visibilities[0][y][x] = viewsByHeight[digit]

        viewsByHeight.set(0 .. digit, 0)
        viewsByHeight.inc((digit + 1) .. 9, 1)

    viewsByHeight.set(0 .. 9, 0)

    for x in countdown(width - 1, 0):
        let digit = digit(x, y)

        visibilities[1][y][x] = viewsByHeight[digit]

        viewsByHeight.set(0 .. digit, 0)
        viewsByHeight.inc((digit + 1) .. 9, 1)

for x in 0 ..< width:
    var viewsByHeight: array[0 .. 9, int]

    for y in 0 ..< height:
        let digit = digit(x, y)

        visibilities[2][y][x] = viewsByHeight[digit]

        viewsByHeight.set(0 .. digit, 0)
        viewsByHeight.inc((digit + 1) .. 9, 1)

    viewsByHeight.set(0 .. 9, 0)

    for y in countdown(height - 1, 0):
        let digit = digit(x, y)

        visibilities[3][y][x] = viewsByHeight[digit]

        viewsByHeight.set(0 .. digit, 0)
        viewsByHeight.inc((digit + 1) .. 9, 1)

for x in 0 ..< width:
    for y in 0 ..< height:
        let left  = visibilities[0][y][x]
        let right = visibilities[1][y][x]
        let up    = visibilities[2][y][x]
        let down  = visibilities[3][y][x]

        if left == x or up == y or right == (width - x - 1) or down == (height - y - 1):
            visibleTrees += 1

        let scenicScore = left * right * up * down

        if scenicScore > bestScenicScore:
            bestScenicScore = scenicScore

echo "visible trees: ", visibleTrees
echo "best scenic score: ", bestScenicScore
