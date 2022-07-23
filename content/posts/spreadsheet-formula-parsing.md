---
title: "Spreadsheet Formula Parsing"
date: 2022-07-23T15:29:21+01:00
tags: [spreadsheets]
draft: false
---

hello world

```
    formulas::evaluate(
        "= SUM("
            "\"hello\", "
            "A2, "
            "A2:B3, "
            "AVERAGE(COL(A), ROW(20), foo, BAR)"
        ") / (1 + 2) * (A2 + C13)");

```

and then

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
