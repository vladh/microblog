---
title: "Easy nocheckin with git"
date: 2022-08-14T14:05:00+01:00
location: London, England
tags: [programming]
draft: false
---

Sometimes, you want to add some code to test something out, but you definitely
want to make sure you don't `git commit` it. Of course, you should always check
the output of `git diff` before you make a commit (you do, right?), but if you
have a lot of changes things can slip through the cracks.

A solution is to write a comment containing a string such as "nocheckin":

```c
function do_stuff() {
    printf("hello!!! testing!!!\n"); // nocheckin
    call_important_thing();
    call_other_thing();
}
```

Then, you need to set git up such that it refuses to make a commit if it detects
the "nocheckin" string anywhere in your changed files. Here's how to do it.

Save this script somewhere — I put it in `~/.bin/validate-nocheckin`:

```shell
#!/bin/sh -eu

# get the staged files
s_files=$(git diff --name-only --cached)

# if a staged file contains the keyword, fail the commit
for s_file in ${s_files};do
    if grep -q -E 'nocheckin' ${s_file};then
        echo "ERROR: ${s_file} contains 'nocheckin', failing commit"
        exit 1
    fi
done

exit 0
```

Then, whenever you want this feature, simply symlink that script as the
[pre-commit
hook](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks#_git_hooks) by
running this from the root folder of your git repository:

```plain
ln -s ~/.bin/validate-nocheckin .git/hooks/pre-commit
```

If you then try to commit your code, it won't work:

```plain
vladh ki test:master $ git commit -m 'will it work?'
ERROR: main.c contains 'nocheckin', failing commit
```
