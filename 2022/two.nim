import strutils

type
    Play = enum
        pRock, pPaper, pScissors

proc toPlay(c: char): Play =
    case c
    of 'A', 'X':
        return pRock
    of 'B', 'Y':
        return pPaper
    of 'C', 'Z':
        return pScissors
    else:
        raise Exception.newException("invalid character '" & $c & "'!")

proc determinePlay(opponent: Play, command: char): Play =
    case command
    of 'X':
        # lose
        var ordinal = opponent.ord - 1
        if ordinal == -1: ordinal = 2

        return Play(ordinal)
    of 'Y':
        # draw
        return opponent
    of 'Z':
        # win
        var ordinal = opponent.ord + 1
        if ordinal == 3: ordinal = 0

        return Play(ordinal)
    else:
        raise Exception.newException("invalid command '" & $command & "'!")

proc battle(player, opponent: Play): int =
    if player == opponent:
        # draw
        return 3

    if (player.ord + 1) mod (Play.high.ord + 1) == opponent.ord:
        # loss
        return 0
    else:
        # win
        return 6

proc score(a, b: char): int =
    when defined(a):
        let opponent = a.toPlay
        let player = b.toPlay
    elif defined(b):
        let opponent = a.toPlay
        let player = determinePlay(opponent, b)
    else:
        let opponent = Play(0)
        let player = Play(0)

        echo "symbol 'a' or 'b' must be defined for parts!"
        quit(0)

    result += player.ord + 1
    result += battle(player, opponent)

var total = 0

for line in readFile("./data/2.txt").split("\n"):
    if line == "":
        continue

    let a = line[0]
    let b = line[2]

    total += score(a, b)

echo total
