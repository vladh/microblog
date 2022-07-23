---
title: "Spreadsheet Formula Parsing"
date: 2022-07-23T15:29:21+01:00
location: London, England
tags: [spreadsheets]
draft: false
---

Lately, I've been working on a spreadsheet program. I think spreadsheets are
cool and I often need to use them, but the current software could be a lot
better. :) You basically have to choose between impossibly overcomplicated
Excel or an army of open-source clones that don't learn from its mistakes.

Anyway, the really fun part about working on spreadsheet software is that you
have to implement a programming language for it! I'm referring to the formula
language we all know and love: `SUM(A1:B3, 150)` and all that.

I've started work on implementing something not too far from what Excel has.
So far, I've written the lexer and the parser. Let's take some sample input:

```plain
= CONCAT(
    "hello",
    SUM(
        A2,
        A2:B3,
        AVERAGE(COL(A), ROW(20))
    ) / (1 + 2) * A2:B3:C4
)
```

The first step is to lex this into lexemes (e.g. `SUM`). Let's run the lexer
on the above expression.

```plain
name lparen literal comma name lparen cellref comma cellref range cellref comma name lparen name lparen name rparen comma name lparen literal rparen rparen rparen div lparen literal plus literal rparen times cellref range cellref range cellref rparen eof
```

Oof! Now we need to convert each lexeme to a token (e.g. `TokenType::name`),
then parse all of the tokens into an AST (abstract syntax tree) made up of
various kinds of expressions. For example, `SUM()` translates to the lexemes
`SUM`, `(` and `)`, which are of lexical type `name`, `lparen`, `rparen`,
which all ends up being translated into an `ExprCall`, because this is a
function call expression. Let's run the parser.

```plain
call[CONCAT]
  literal[str, hello]
  binarithm[*]
    binarithm[/]
      call[SUM]
        cellref[A2]
        binarithm[:]
          cellref[A2]
          cellref[B3]
        call[AVERAGE]
          call[COL]
            name[A]
          call[ROW]
            literal[i64, 20]
      binarithm[+]
        literal[i64, 1]
        literal[i64, 2]
    binarithm[:]
      binarithm[:]
        cellref[A2]
        cellref[B3]
      cellref[C4]
```

Looks about right! :)

The next step is to actually write the evaluator, which will walk this abstract
syntax tree, evaluate all the expressions and return the result of the whole
thing. In our above case, it would probably be, like, `hello57` or something,
depending on what's in your spreadsheet.
