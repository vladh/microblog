---
title: "Spreadsheet Formula Parsing"
date: 2022-07-23T15:29:21+01:00
location: London, England
tags: [spreadsheets, potato]
draft: false
---

It’s 2021, and we’ve broken the way we program. We have more tutorials, Stack Overflow answers and programming courses than ever. Our computers are more powerful than ever. There are many software developers who can piece together a mesh of libraries to create cross-platform applications.

However, we seem to have lost our understanding of what the computer is actually doing under all that code. We barely know how the dependencies we are npm install-ing work, let alone what the CPU is doing. More than that, if we had to develop, from scratch, one of these tools or frameworks that we use on a daily basis, we’d probably be lost.

```
formulas::evaluate(
    "= SUM("
        "\"hello\", "
        "A2, "
        "A2:B3, "
        "AVERAGE(COL(A), ROW(20), foo, BAR)"
    ") / (1 + 2) * (A2 + C13)");
```

However, we seem to have lost our understanding of what the computer is actually doing under all that code. We barely know how the dependencies we are npm install-ing work, let alone what the CPU is doing. More than that, if we had to develop, from scratch, one of these tools or frameworks that we use on a daily basis, we’d probably be lost.

```
# Formula:
= SUM("hello", A2, A2:B3, AVERAGE(COL(A), ROW(20), foo, BAR)) / (1 + 2) * (A2 + C13)

# AST:
binarithm[*]
    binarithm[/]
        call[SUM]
            literal[str, hello]
            cellref[A2]
            binarithm[:]
                cellref[A2]
                cellref[B3]
            call[AVERAGE]
                call[COL]
                    name[A]
                call[ROW]
                    literal[i64, 20]
                name[foo]
                name[BAR]
        binarithm[+]
            literal[i64, 1]
            literal[i64, 2]
    binarithm[+]
        cellref[A2]
        cellref[C13]

# Result:
error | Don't know how to evaluate Expr of type: binarithm
(none)
```
