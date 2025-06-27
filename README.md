![CthulhuMergeFinal](https://github.com/Milnor/Git-Tricks/assets/7789866/3b7c5f6e-f845-4d71-a0b1-a003a2fa7f7a)
# Git Tricks

Stuff that is difficult to do in git (but sometimes important).

## Introduction

Here I document things dug up elsewhere that I don't want to forget.
There is a fantastic series of blog posts by Raymond Chen of Microsoft.

## Preserving `git blame history`

TODO: Describe the challenge of preserving line authorship.
Sometimes a fancy "octopus merge" is the way to do it.

### Copying Files

### Concatenating Files

## Insert Content from Another Repository

I learned about `git subtree` after I had students commit their group projects to an external repository rather than our main class repository where I wanted
it to reside. Although I could have used a copy command to move their content into our main course repo, I didn't want to lose the commit history which documented each individual's participation in the project.

```format
git subtree add --prefix=<subfolder name> <git repository> <branch>
```

```example
git subtree add --prefix=lesson_plans https://github.com/Milnor/Git-Tricks.git main
```

Incidentally, `subtree` is not a native `git` command. It is a third-party convenience script that has been bundled with git for over a decade.

## Bibliography

* Chen, Raymond. [Mundane git tricks: Combining two files into one while preserving line history](https://devblogs.microsoft.com/oldnewthing/20190514-00/?p=102493) May 14, 2019.

* Deckstar. [How to "Git Copy": copying files while keeping git history](https://dev.to/deckstar/how-to-git-copy-copying-files-while-keeping-git-history-1c9j) Aug. 16, 2022.

* Gitschooldude, Dan. [032 Introduction to Git Subtrees](https://www.youtube.com/watch?v=sC1sfoCo5qY) Jan. 6, 2019.
