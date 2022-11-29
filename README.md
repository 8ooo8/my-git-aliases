# My Git aliases

The Git operations can be intensive for various reasons, for example,

1. to deliver quality code, it is suggested to review our working directory before making a commit
1. the team runs code review and therefore need to frequently modify previous commits
1. need to review own commits because the code review feedback for one of our commits actually affects the others
1. distracted by other tasks and hence forget what we have made to the codebases
1. need to search for the commits of similar features as a reference for the new feature development, to help avoid mistakenly missing something in our implementation
1. too many unknowns with the huge and complex codebases and may need to use stash to temporarily store the code changes made during the PoC or trial-and-error
1. ...


Therefore, I have written this [script][config-sh] to set up my Git aliases. Yet, this is quite complicated, but the aliases follow certin patterns to help you memorize them and once you get used to them, your productivity will be significantly improved.

# Quick start

1. clone the project
    ```zsh
    git clone https://github.com/8ooo8/my-git-aliases/
    ```
1. modify [set-git-config.sh][config-sh]
    1. ensure it correctly points to your Bash or Zsh
        ```zsh
        #!/bin/zsh
        ```
        1. check the shell currently in use if needed
            ```zsh
            echo $SHELL
            ```
    1. write down your username, email, favourite editor and pager
        ```zsh
        myGitUserName='8ooo8'
        myGitUserEmail='ben.cky.workspace@gmail.com'
        myEditor='nvim'
        myPager='less'
        myGerritRemote='origin'
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
