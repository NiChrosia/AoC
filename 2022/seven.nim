import tables, strutils

let input = """$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k"""

type
    Node = object
        name: string
        size: int

        children: Table[string, Node]

proc isFolder(n: Node): bool =
    return n.children.len > 0

var tree = Node(name: "", size: 0)
var current: Node

for line in input.split("\n"):
    if line.contains("$ cd"):
        let directory = line[5 .. line.high]

        if directory == "/":
            current = tree
        else:
            current = tree[directory]
    elif line.contains("$ ls"):
        discard
    else:
        discard
