import strutils, deques, sequtils

let input = readFile("./data/5.txt")

var boxes: seq[Deque[char]]
var count = 0

for line in input.split("\n"):
  if line.contains("["):
    # box line
    if count == 0:
      count = (line.len + 1) div 4
      
      for index in 1 .. count:
        boxes.add(initDeque[char]())
    
    for index in boxes.low .. boxes.high:
      let charIndex = index * 4 + 1
      let char = line[charIndex]
      
      if char == ' ':
        continue
      
      boxes[index].addFirst(char)
  elif line.contains("move"):
    # movement command
    # \r has occasionally been in the input data, so remove it
    var parts = line.split(" ").mapIt(it.replace("\r", ""))
    
    let count = parseInt(parts[1])
    # indices start with 0
    let source = parseInt(parts[3]) - 1
    let dest = parseInt(parts[5]) - 1
    
    when defined(a):
      for i in 1 .. count:
        boxes[dest].addLast(boxes[source].popLast())
    else:
      var queue = initDeque[char]()
      
      for i in 1 .. count:
        queue.addLast(boxes[source].popLast())
        
      for i in 1 .. count:
        boxes[dest].addLast(queue.popLast())

var height = 0

for box in boxes:
  if box.len > height:
    height = box.len

for row in countdown(height - 1, 0, 1):
  for index in 0 .. boxes.high:
    let box = boxes[index]
    let high = box.len - 1
    
    if row > high:
      # this box doesn't reach this row
      stdout.write "   "
    else:
      # this box does
      stdout.write "["
      stdout.write $box[row]
      stdout.write "]"
    
    if index < boxes.high:
      # write spacing if partially through
      stdout.write " "
    else:
      # otherwise finish it with a newline
      stdout.write "\n"
