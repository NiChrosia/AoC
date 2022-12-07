import tables, strutils

let input = readFile("./data/7.txt")

type
    Node = object
        name: string
        size: int

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

    result &= " ".repeat(indent) & n.name & "\n"
    
    for c in n.children.values:
        result &= c.`$`(indent + 2)

var current = Node(name: "", children: {"/": Node(name: "/")}.toOrderedTable)

for line in input.split("\n"):
    if line.contains("$ cd "):
        # change directory
        let directory = line[5 .. line.high]

        if directory == ".." or directory == "..\r":
            current.parent.children[current.name] = current
            current = current.parent[]
        else:
            let parent = current

            current = Node(name: directory)
            current.parent = new(Node)
            current.parent[] = parent
    elif line.contains("$ ls"):
        # do nothing
        discard
    elif line == "":
        # ignore empty lines
        discard
    else:
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

echo "current: "
echo current
echo "parent: "
echo current.parent[]
