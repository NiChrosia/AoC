import std/[monotimes, times, strformat, strutils]
import a, b, b_brute, b_replace

proc bench(text: string, iters, longest: int, name: string, callback: proc(text: string): int) {.inline.} =
    let start = getMonoTime()

    for _ in 1 .. iters:
        discard callback(text)

    let stop = getMonoTime()
    let duration = (stop - start) div iters

    let ns = duration.inNanoseconds
    let us = duration.inMicroseconds
    let ms = duration.inMilliseconds
    let s = duration.inSeconds

    let padding = " ".repeat(longest - name.len)
    var text = fmt"{name} time: {padding}"

    if s > 0 and s < 1000:
        text &= fmt"{s}s {ms mod 1000}ms"
    if ms > 0 and ms < 1000:
        text &= fmt"{ms}ms {us mod 1000}μs"
    if us > 0 and us < 1000:
        text &= fmt"{us}μs {ns mod 1000}ns"
    if ns > 0 and ns < 1000:
        text &= fmt"{ns}ns "

    echo text

let text = readFile("input.txt")

let longest = "b replace".len

bench(text, 1000, longest, "a", a.run)
bench(text, 1000, longest, "b", b.run)
bench(text, 1000, longest, "b brute", b_brute.run)
bench(text, 1000, longest, "b replace", b_replace.run)
