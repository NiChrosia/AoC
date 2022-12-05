import strutils, algorithm

var boxes = newSeq[string]()

proc pop(s: var string, c: int): string =
  result = s[s.high - c + 1 .. s.high]
  s.setLen(s.len - c)
  
var test = "abcde"
discard test.pop(2)
assert test == "abc"

proc push(s: var string, letters: string) =
  s &= letters
    
proc printBoxes() =
  var max = 0
  for box in boxes:
    if box.len > max:
      max = box.len
  
  for row in countdown(max, 1, 1):
    for i in boxes.low .. boxes.high:
      let box = boxes[i]
      
      if box.len < row:
        stdout.write(" ".repeat(3))
      else:
        stdout.write("[")
        stdout.write($box[row - 1])
        stdout.write("]")
      
      if i < boxes.high:
        stdout.write(" ")
      else:
        stdout.write("\n")
        
  for i in boxes.low .. boxes.high:
    stdout.write(" ")
    stdout.write($(i + 1))
    stdout.write(" ")
    
    if i < boxes.high:
      stdout.write(" ")
    else:
      stdout.write("\n")

proc read(input: string) =
  let lines = input.split("\n")
  boxes.setLen((lines[0].len + 1) div 4)
  
  for line in lines:
    if line == "":
      discard
    elif line.contains('['):
      # boxes
      for i in line.low .. line.high:
        let c = line[i]
        
        if c in 'A' .. 'Z':
          let box = (i - 1) div 4
          boxes[box] &= c
    elif line.contains(" 1   2 "):
      # finalize boxes
      for i in boxes.low .. boxes.high:
        boxes[i] = cast[string](boxes[i].reversed())
    elif line.contains("move"):
      # instructions
      let parts = line.split(" ")

      let count = parts[1].parseInt()
      let source = parts[3].parseInt()
      # apparently \r is randomly in the input data
      let destination = parts[5].replace("\r", "").parseInt()
      
      # printBoxes()
      # echo source, " (", count, ") -> ", destination
      
      let letters = boxes[source - 1].pop(count)

      when defined(a):
        let reversed = cast[string](letters.reversed())
      else:
        let reversed = letters
      
      boxes[destination - 1].push(reversed)

let input = readFile("./data/5.txt")

read(input)

for i in boxes.low .. boxes.high:
  let box = boxes[i]
  stdout.write(box[box.high])

stdout.write("\n")
