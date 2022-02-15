# My Git aliases

This repository shares my **Git aliases** which is a **good fit** into environment that:

1. **runs code review**, which requires an intensive modification of the old commits
    1. it allows a quick search, review and rebase of own commits on the current branch
    1. it provides handy stash aliases to quickly save down the current change for future use, e.g. move the current change to a specific commit, help learn about the huge code base using trial-and-error approach
1. **needs to search through the commits to find out the reference code/information** to assist the development
    1. it allows a quick search and review of the commits based on either their commit messages or content

# Quick start

_Please note that this script is still frequently updated and not yet come to its final shape._

1. clone the project
    ```zsh
    git clone https://github.com/8ooo8/my-git-aliases/
    ```
1. modify [set-git-config.sh][config-sh]
    1. ensure it correctly points to your Bash or Zsh
    ```zsh
    #!/bin/zsh
    ```
    1. write down your username, email, favourite editor and pager
    ```zsh
    myGitUserName='8ooo8'
    myGitUserEmail='ben.cky.workspace@gmail.com'
    myEditor='nvim'
    myPager='less'
    ```
    1. add your own aliases or/and configuration, possibly specific for your company, e.g. set the git hooks
    ```zsh
    # [company's specific need, e.g. set git hooks]
    # your own aliases or/and configuration for your company
    ```
1. set execution right for [set-git-config.sh][config-sh]
    ```zsh
    chmod +x set-git-config.sh
    ```
1. run [set-git-config.sh][config-sh]
    ```zsh
    ./set-git-config.sh
    ```

_Please note that this script does not only contain my aliases but also my basic Git config._

# Tested environment

1. zsh 5.8 (x86_64-apple-darwin21.0), git version 2.32.0
1. Git Bash (mintty 3.5.2 (x86_64-pec-msys) [Windows 19043]), git version 2.34.1.windows.1

[config-sh]: set-git-config.sh
