import strutils, sequtils

let input = readFile("data/8.txt")
let rows = input.split("\n").mapIt(it.replace("\r", "")).filterIt(it != "")

let rowHigh = rows[0].high
let colHigh = rows.high

echo rowHigh
echo colHigh

type
    # this could be optimized into an int16
    View = object
        left, right, down, up: int
        visible: bool

proc digit(x, y: int): int =
    if x in 0 .. rowHigh and y in 0 .. colHigh:
        return ord(rows[y][x]) - ord('0')
    else:
        # zero
        discard

var views = newSeqWith(colHigh + 1, newSeq[View](rowHigh + 1))

proc view(x, y: int): View =
    if x in 0 .. rowHigh and y in 0 .. colHigh:
        return views[y][x]
    else:
        # default to zeroed out view
        discard

# left -> right
for y in 0 .. colHigh:
    for x in 0 .. rowHigh:
        let digit = digit(x - 1, y)
        let highest = view(x - 1, y).left

        views[y][x].left = max(digit, highest)

# right -> left
for y in 0 .. colHigh:
    for x in countdown(rowHigh, 0):
        let digit = digit(x + 1, y)
        let highest = view(x + 1, y).right

        views[y][x].right = max(digit, highest)

# down -> up
for x in 0 .. rowHigh:
    for y in countdown(colHigh, 0):
        let digit = digit(x, y + 1)
        let highest = view(x, y + 1).down

        views[y][x].down = max(digit, highest)

# up -> down
for x in 0 .. rowHigh:
    for y in 0 .. colHigh:
        let digit = digit(x, y - 1)
        let highest = view(x, y - 1).up

        views[y][x].up = max(digit, highest)

        # check visibility
        let d = digit(x, y)
        let view = views[y][x]

        # trees with zero height and a path of zero height count as visible, annoyingly
        if d > view.left or (d == view.left and d == 0):
            views[y][x].visible = true
        if d > view.right or (d == view.right and d == 0):
            views[y][x].visible = true
        if d > view.down or (d == view.down and d == 0):
            views[y][x].visible = true
        if d > view.up or (d == view.up and d == 0):
            views[y][x].visible = true

var totalVisible = 0

for y in 0 .. colHigh:
    for x in 0 .. rowHigh:
        if views[y][x].visible:
            stdout.write "X"
            totalVisible += 1
        else:
            stdout.write " "

    stdout.write "\n"

echo "in total: ", totalVisible
