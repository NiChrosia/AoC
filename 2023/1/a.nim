import strutils

let text = readFile("input.txt")
var sum = 0

for line in text.split("\n"):
  for c in line:
    if c in '1' .. '9':
      sum += 10 * (ord(c) - ord('0'))
      break
  
  for i in countdown(line.high, 0):
    if line[i] in '1' .. '9':
      sum += ord(line[i]) - ord('0')
      break

echo sum
