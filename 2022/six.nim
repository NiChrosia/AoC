import deques

const count = when defined(a):
    4
else:
    14

let input = readFile("./data/6.txt")

proc checkEquality(window: Deque[char]): bool =
  var i = 0
  var j = i + 1
  
  while i < count:
    while j < count:
      if window[i] == window[j]:
        return false
        
      j += 1
        
    i += 1
    j = i + 1
  
  return true

var window: Deque[char]

for index in input.low .. input.high:
  let c = input[index]
  
  window.addLast(c)
  
  if window.len > count:
    discard window.popFirst()
    
    let unique = window.checkEquality()
    
    if unique:
      echo $window, " @ ", $(index + 1)
      break
