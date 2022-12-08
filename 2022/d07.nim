import tables, strutils, sequtils, algorithm

let input = readFile("./data/7.txt")

type
    Node = object
        name: string
        size, summedSize: int

        parent: ref Node
        children: OrderedTable[string, Node]

proc isFolder(n: Node): bool =
    return n.size == 0

proc `$`(n: Node, indent: int = 0): string =
    var name: string

    if n.isFolder:
        name = n.name & "/"
    else:
        name = n.name & ": " & $n.size

    result &= " ".repeat(indent) & name & "\n"
    
    for c in n.children.values:
        result &= c.`$`(indent + 2)

var current = Node(name: "", children: {"/": Node(name: "/")}.toOrderedTable)

# part a
var thresholdSum = 0

# part b
var sums: seq[int]

proc cd(line: string) =
    # change directory
    var directory = line[5 .. line.high]
    directory = directory.replace("\r", "")

    if directory == ".." or directory == "..":
        current.parent.children[current.name] = current
        current.parent.summedSize += current.summedSize

        if current.summedSize <= 100_000:
            thresholdSum += current.summedSize

        sums.add(current.summedSize)

        current = current.parent[]
    else:
        let parent = current

        current = Node(name: directory)
        current.parent = new(Node)
        current.parent[] = parent

proc addEntry(line: string) =
    # add to current node
    if line.contains("dir "):
        # directory
        let name = line[4 .. line.high]

        current.children[name] = Node(name: name)
    else:
        # file
        let space = line.find(" ")

        let size = parseInt(line[0 .. space - 1])
        let name = line[space + 1 .. line.high]

        current.children[name] = Node(name: name, size: size)
        current.summedSize += size

for line in input.split("\n").mapIt(it.replace("\r", "")):
    if line.contains("$ cd "):
        cd(line)
    elif line.contains("$ ls"):
        # do nothing
        discard
    elif line == "":
        # ignore empty lines
        discard
    else:
        addEntry(line)

cd("$ cd ..")

echo "current: "
echo current

# part a
echo "threshold sum: ", thresholdSum

# part b
sums.sort()

let unused = 70_000_000 - current.summedSize
let required = 30_000_000 - unused

for sum in sums:
    if sum >= required:
        echo "smallest directory to delete: ", sum
        break
