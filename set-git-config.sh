#!/bin/zsh

myGitUserName='8ooo8'
myGitUserEmail='ben.cky.workspace@gmail.com'
myEditor='nvim'
myPager='less'
myGerritRemote='origin'

# -- user --
git config --global user.name "$myGitUserName"
git config --global user.email "$myGitUserEmail"

# -- core --
git config --global core.eol lf
git config --global core.autocrlf false
git config --global core.editor "$myEditor"
git config --global core.pager "$myPager"
git config --global core.filemode false
git config --global core.longpaths true

# -- alias --

# clear git aliases to remove all obsolete or renamed aliases
(
gitConfigPath=${HOME}/.gitconfig

gitSectionStartLines=$(grep -En '^\[' $gitConfigPath)
aliasSectionIndex=$(grep -ni alias <<< $gitSectionStartLines | awk -v FS=':' '{print $1}')
if [[ ! -z "${aliasSectionIndex}" ]]
then
    aliasNextSectionIndex=$(($aliasSectionIndex + 1))
    aliasSectionStartLine=$(awk -v FS=':' "NR==${aliasSectionIndex}{print \$1}" <<< $gitSectionStartLines)
    ttlNumberOfSections=$(awk 'END{print NR}' <<< $gitSectionStartLines)
    if (($ttlNumberOfSections >= $aliasNextSectionIndex))
    then
        aliasSectionEndLine=$(($(awk -v FS=':' "NR==${aliasNextSectionIndex}{print \$1}" <<< $gitSectionStartLines) - 1))
    else
        aliasSectionEndLine=$(awk 'END{print NR}' $gitConfigPath)
    fi
    gitConfigWithoutAlias=$(awk "{if ($aliasSectionStartLine > NR || NR > $aliasSectionEndLine) print}" $gitConfigPath)
    echo "$gitConfigWithoutAlias" > $gitConfigPath
fi
)

# [config]
git config --global alias.cf 'config'
git config --global alias.cfl 'config --list'
git config --global alias.cfg 'config --global'
git config --global alias.cfgl 'config --global --list'

# [push]
git config --global alias.ps 'push'
git config --global alias.psu 'push -u'
## note that to push specific tag, use `git push <REMOTE> <TAGNAME>`
git config --global alias.psta 'push --tags' # git psta [REMOTE]; all refs under refs/tags are pushed, in addition to refspecs explicitly listed on the command line.
git config --global alias.psfta 'push --follow-tags' # git psfta [REMOTE]; push all the refs that would be pushed without this option, and also push ANNOTATED tags in refs/tags that are missing from the remote but are pointing at commit-ish that are reachable from the refs being pushed
git config --global alias.psd 'push -d' # common usage: git psd <REMOTE> <TAGNAME>
git config --global alias.psge '!sh -c '"'git push $myGerritRemote HEAD:refs/for/\"\$1\"' - " # git psge <BRANCH-NAME>

# [clone]
git config --global alias.clo 'clone'

# [pull]
git config --global alias.pl 'pull'
git config --global alias.plal 'pull --all'
git config --global alias.plrs 'pull --recurse-submodules'

# [fetch]
git config --global alias.fe 'fetch'
git config --global alias.feal 'fetch --all'

# [remote]
git config --global alias.rem 'remote'
git config --global alias.remv 'remote -v'

# [checkout]
## Note that to prevent our shell expend the pathspec, which takes wildcard char, quotes or backslash is needed.
## https://css-tricks.com/git-pathspecs-and-how-to-use-them/ for more info.
git config --global alias.co 'checkout'
## alias naming: <co><h>
git config --global alias.coh '!sh -c '"'git checkout head\${1:-~1}' - " # git coh [<SUFFIX-TO-BE-APPENDED-TO-HEAD> [PATHSPEC]]; the alias suffix 'h' means Head
## alias naming: <co><f|p>[h|hc]
git config --global alias.cof 'checkout -f'
git config --global alias.cofh '!sh -c '"'git checkout -f head\${1} -- \${@:2}' - " # git cofh [<SUFFIX-TO-BE-APPENDED-TO-HEAD> [PATHSPEC]]; e.g. git cofh \~1 \*XXxx\*
git config --global alias.cofhc '!sh -c '"'git checkout -f head -- \${@:1}' - " # git cofhc <PATHSPEC>; the alias suffix 'c' refers the commit Currently pointed by head
git config --global alias.coph '!sh -c '"'git checkout -p head\${1} -- \${@:2}' - " # git coph [<SUFFIX-TO-BE-APPENDED-TO-HEAD> [PATHSPEC]]
git config --global alias.cophc '!sh -c '"'git checkout -p head -- \${@:1}' - " # git cophc [PATHSPEC]
## alias naming: <co><b|ou|th>
git config --global alias.cob 'checkout -b'
git config --global alias.coou 'checkout --ours' # e.g. git coou .; git coou *java;
git config --global alias.coth 'checkout --theirs'

# [merge]
git config --global alias.me 'merge'
git config --global alias.mec 'merge --continue'
git config --global alias.mea 'merge --abort'
git config --global alias.meq 'merge --quit'

# [reflog]
git config --global alias.rl 'reflog'
git config --global alias.rld 'reflog --date=relative'
git config --global alias.rla 'reflog --all'

# [commit]
## alias naming: <cm>[a|p][ad|m]
git config --global alias.cm 'commit'
git config --global alias.cmm 'commit -m'
git config --global alias.cmad 'commit --amend'

git config --global alias.cma 'commit -a' # -a automatically stage files that have been modified and deleted, but new files you have not told Git about are not affected.
git config --global alias.cmp 'commit -p' # git cmp [PATHSPEC]

git config --global alias.cmam 'commit -a -m' # git cmam <COMMIT-MSG>
git config --global alias.cmpm 'commit -p -m' # git cmpm <COMMIT-MSG> [PATHSPEC]

git config --global alias.cmaad 'commit -a --amend'
git config --global alias.cmpad 'commit -p --amend'

## alias naming: <cm><ae>[m]
git config --global alias.cmae 'commit --allow-empty' # allow making a commit with an unchanged tree, which can be useful for adding a version number
git config --global alias.cmaem 'commit --allow-empty -m'

# [rebase]
git config --global alias.rb 'rebase'
git config --global alias.rbot 'rebase --onto'
git config --global alias.rba 'rebase --abort'
git config --global alias.rbc 'rebase --continue'
git config --global alias.rbs 'rebase --skip'
git config --global alias.rbed 'rebase --edit-to'
git config --global alias.rbi 'rebase -i'
git config --global alias.rbir 'rebase -i --root'
## alias 'rbip' example: `git rbip origin/branch-name` to modify the commits not yet pushed
git config --global alias.rbip '!sh -c '"'git rebase -i \"\$1\"~1' - " # rebase on the parent of the specified commit, e.g. on head~1~1 if head~1 is specified; the alias suffix 'p' refers to the Parent commit of the specified commit
git config --global alias.rbihp '!sh -c '"'git rebase -i head\"\$1\"~1' - " # rebase on the parent of the specified commit, e.g. on head~2~1 if \~1 is specified

# [cherry-pick]
git config --global alias.cp 'cherry-pick'
git config --global alias.cpa 'cherry-pick --abort'
git config --global alias.cpc 'cherry-pick --continue'
git config --global alias.cps 'cherry-pick --skip'

# [revert]
git config --global alias.rvt 'revert'
git config --global alias.rvta 'revert --abort'
git config --global alias.rvtc 'revert --continue'
git config --global alias.rvts 'revert --skip'

# [add]
git config --global alias.a 'add' # note that `git add .` does not stage the deleted files
git config --global alias.aa 'add -A' # -A means --all
git config --global alias.au 'add -u' # -u means untracked files, i.e. not including new files
git config --global alias.ap 'add -p'
git config --global alias.ai 'add -i'
git config --global alias.air 'git add --ignore-removal .'

# [log]
## Basic
## example: say you have created a branch from master for a hot fix issue and you would like to view the commits made for the issue, `git l master..` may help
git config --global alias.l 'log'

## List (own) commits, OR
## search across all branches / through current branch for (own) commits (by commit messages / committed changes)
### usage: git ALIAS [COMMIT-MSG-OR-COMMITED-CHANGES]
### alias naming: <l>[a|c][o|p|st][r][i][s|ge|gr]
### example: when you would like to read the commit message for a specific line of code, `git las 'THE-LINE-OF-CODE'` may help
### example: say you would like to view all your commits on the current branch, `git lco` may help
### example: say you would like to view your last committed changes, `git lp -1` may help
### example: say you would like to view your committed changes for a specific file, `git lp '*part-of-the-filename*'` may help
(
logAliasesPart2=(':' 'a:--all' "c:--committer \"$myGitUserEmail\"")
logAliasesPart3=(':' 'o:--oneline' 'p:-p' 'st:--stat')
logAliasesPart4=(':' 'r:--reverse')
logAliasesPart5=(':' 'i:-i')
logAliasesPart6=(':' 's:-S' 'ge:-G' 'gr:--grep') # to search the commited changes: -S (by string), -G (by regex); to search the commit msg: --grep (by string)
for p2 in "${logAliasesPart2[@]}"
do
    for p3 in "${logAliasesPart3[@]}"
    do
        for p4 in "${logAliasesPart4[@]}"
        do
            for p5 in "${logAliasesPart5[@]}"
            do
                for p6 in "${logAliasesPart6[@]}"
                do
                    aliasName="l${p2%:*}${p3%:*}${p4%:*}${p5%:*}${p6%:*}"
                    aliasCmd=$(echo -e "log ${p2#*:} ${p3#*:} ${p4#*:} ${p5#*:} ${p6#*:}" | awk '{$1=$1}1')
                    sh -c "git config --global alias.${aliasName} '${aliasCmd}'"
                done
            done
        done
    done
done
)

## List all (own) commits SINCE a specific commit on the current branch
### alias naming: <l>[c][o|p|st][r][i][s|ge|gr]<ph>
### alias suffix 'ph' means from the Parent of the specified commit to Head, i.e. ${1}~1..head below
### example: say you have created a branch from master for a hot fix issue and you would like to review only your hot fix commits, `git lprph master` may help
(
logAliasesPart2=(':' "c:--committer \"$myGitUserEmail\"")
logAliasesPart3=(':' 'o:--oneline' 'p:-p' 'st:--stat')
logAliasesPart4=(':' 'r:--reverse')
logAliasesPart5=(':' 's:-S' 'ge:-G' 'gr:--grep' 'is:-i -S' 'ige:-i -G' 'igr:-i --grep')
for p2 in "${logAliasesPart2[@]}"
do
    for p3 in "${logAliasesPart3[@]}"
    do
        for p4 in "${logAliasesPart4[@]}"
        do
            for p5 in "${logAliasesPart5[@]}"
            do
                if [[ -z "$(echo $p5 | sed 's/://')" ]]
                then
                    #### alias naming: <l>[c][o|p|st][r]<ph>
                    #### usage: git ALIAS <COMMIT-POINTER-OR-COMMIT-HASH>
                    aliasName="l${p2%:*}${p3%:*}${p4%:*}ph"
                    aliasCmd="${p2#*:} ${p3#*:} ${p4#*:}"
                    aliasCmd="\"git log ${aliasCmd} \${1}~1..head\"" # PARENT-OF-SPECIFIED-COMMIT..head instead of SPECIFIED-COMMIT..head to include the specified commit in the log view
                    aliasCmd='!sh -c '"${aliasCmd}"' - '
                    sh -c "git config --global alias.${aliasName} '${aliasCmd}'"
                else
                    #### alias naming: <l>[c][o|p|st][r][i]<s|ge|gr><ph>
                    #### usage: git ALIAS <COMMIT-MSG-OR-COMMITTED-CHNAGES>
                    aliasName="l${p2%:*}${p3%:*}${p4%:*}${p5%:*}ph"
                    aliasCmdPart1="git log ${p2#*:} ${p5#*:} '\\\${1}' --pretty='%h' | head -1" # get the most recent commit among the search result
                    aliasCmdPart2="xargs -o -I{} git log ${p2#*:} ${p3#*:} ${p4#*:} {}~1..head"
                    aliasCmd="'"'!sh -c '"'\"\\\"${aliasCmdPart1} | ${aliasCmdPart2}\\\"\"' - '"
                    sh -c "git config --global alias.${aliasName} ${aliasCmd}" # e.g. git lorigrph '\[ver\]'
                fi
            done
        done
    done
done
)

## Search for own commit and rebase on its parent
### usage: git ALIAS
git config --global alias.lcrbp '!sh -c '"'git rebase -i \$(git log --committer \"$myGitUserEmail\" --oneline --reverse --pretty=\"%h\" | head -1)~1'" # rebase on the parent of your earliest commit on the current branch. it will fail if no such parent.
### usage: git ALIAS <COMMIT-MSG>
git config --global alias.lcgrrbp '!sh -c '"'git log --committer \"$myGitUserEmail\" --pretty=\"%h\" --grep \"\$1\" -1 | xargs -o -I@ git rebase -i @~1' - " # rebase on the parent of the most recent commit whose message matches <COMMIT-MSG>. it will fail if no such parent.
git config --global alias.lcigrrbp '!sh -c '"'git log --committer \"$myGitUserEmail\" --pretty=\"%h\" -i --grep \"\$1\" -1 | xargs -o -I@ git rebase -i @~1' - " # rebase on the parent of the most recent commit whose message matches <COMMIT-MSG>. it will fail if no such parent.
### usage: git log ... | git ALIAS
git config --global alias.awkrbip '!sh -c '"\"awk 'NR=1{print \\\$1}' | xargs -o -I{} git rebase -i {}~1\"" # crop the commit hash from the 1st line of previous git command output and rebase on its parent. it will fail if no such parent.
### In general, `git lcrbp` and `git rbip THE-BRANCH-FROM-WHICH-THE-CURRENT-BRANCH-WAS-CREATED` are already good enough to fulfil our git-rebase need

## Graph
git config --global alias.laog 'log --graph --oneline --all'

# [status]
git config --global alias.stt 'status'
git config --global alias.sttun 'status -uno' # do not show the untracked files
git config --global alias.sttua 'status -uall' # -uall actually is the default value for `git status`
git config --global alias.sttv 'status -v'

# [stash]
## push
## alias naming: <sts> or <stsps>[u|a][k][m]
stashPushAlias='stsps'
sh -c "git config --global alias.${stashPushAlias} 'stash'"
git config --global alias.sts 'stash' # shorthand alternative for stash push
sh -c "git config --global alias.${stashPushAlias}m 'stash push -m'"
sh -c "git config --global alias.${stashPushAlias}k 'stash push -k'" # -k, i.e. --keep-index (all changes already added to the index are left intact)
sh -c "git config --global alias.${stashPushAlias}km 'stash push -k -m'"

sh -c "git config --global alias.${stashPushAlias}u 'stash push -u'" # -u, i.e. --include-untracked
sh -c "git config --global alias.${stashPushAlias}um 'stash push -u -m'"
sh -c "git config --global alias.${stashPushAlias}uk 'stash push -u -k'"
sh -c "git config --global alias.${stashPushAlias}ukm 'stash push -u -k -m'"

sh -c "git config --global alias.${stashPushAlias}a 'stash push -a'" # -a, i.e. --all (tracked, untracked and ignored files are all put into the stash)
sh -c "git config --global alias.${stashPushAlias}am 'stash push -a -m'"
sh -c "git config --global alias.${stashPushAlias}ak 'stash push -a -k'"
sh -c "git config --global alias.${stashPushAlias}akm 'stash push -a -k -m'"

## list
git config --global alias.stsl 'stash list'
git config --global alias.stslb 'stash list --before'
git config --global alias.stsla 'stash list --after'
git config --global alias.stslp 'stash list -p' # note that it does not show the untracked files

## apply
git config --global alias.stsa 'stash apply'
git config --global alias.stsai 'stash apply --index' # --index tries to also reinstate the index

## show
### alias naming: <stssh>[p][u]
git config --global alias.stssh 'stash show' # e.g. git stssh; git stssh 1;
git config --global alias.stsshu 'stash show -u' # -u, i.e. --include-untracked
git config --global alias.stsshp 'stash show -p'
git config --global alias.stsshpu 'stash show -p -u'

### pop, drop, clear
git config --global alias.stspo 'stash pop'
git config --global alias.stsd 'stash drop'
git config --global alias.stsc 'stash clear'

### Checkout specific file(s) in a specific stash entry
git config --global alias.stscof '!sh -c '"'git checkout -f stash@\{\${1:-0}\} -- \${@:2}' - " # git stscof [<STASH-ENTRY-NUMBER> [PATHSPEC]]; default: stash@{0}
git config --global alias.stscop '!sh -c '"'git checkout -p stash@\{\${1:-0}\} -- \${@:2}' - " # git stscop [<STASH-ENTRY-NUMBER> [PATHSPEC]]; default: stash@{0}

### stash > stash apply, to create a temporarily checkpoint for some / all of the changes, while leaving the index & the working tree intact
git config --global alias.sts-aiq '!sh -c '"'git ${stashPushAlias}\"\$@\" && git stash apply --index -q' - " # git sts-aiq [SUFFIX-TO-FORM-STASH-PUSH-ALIAS [ARGUMENTS-TO-STASH-PUSH]], e.g. git sts-aiq m 'stash-message'

### diff stash@{?}
#### Use below alias to ensure no needed change is missed when the stash becomes messy
git config --global alias.dsts '!sh -c '"'git diff stash@\{\${1:-0}\}' - " # git dsts [STASH-ENTRY-NUMBER]; default: stash@{0}

### add > stash apply
git config --global alias.austsa '!sh -c '"'git au && git stash apply \"\${1:-0}\"' - " # git austsa [STASH-ENTRY]; default: stash@{0}

### reset --hard > stash apply
git config --global alias.rshqstsai '!sh -c '"'git reset --hard -q && git stash apply --index \"\${1:-0}\"' - " # git rshqstsai [STASH-ENTRY]; default: stash@{0}

# [diff]
## suggested to call below aliases to check your change before making a new commit or amending your previous commit, especially when there is time-consuming git-hook work for commit
## alias naming: <d>[nus][h|hp] or <d>[c][nus][hp]
git config --global alias.d 'diff' # git d [COMMIT]; show the diff between the working tree and COMMIT, whose default is the index
git config --global alias.dc 'diff --cached' # git dc [COMMIT]; show the diff between index and COMMIT, whose default is HEAD
git config --global alias.dh 'diff head' # show the diff between the working tree and HEAD
git config --global alias.dhp 'diff head~1'
git config --global alias.dchp 'diff --cached head~1'

git config --global alias.dnus 'diff --numstat' # show number of added and deleted lines
git config --global alias.dcnus 'diff --cached --numstat'
git config --global alias.dnush 'diff --numstat head'
git config --global alias.dnushp 'diff --numstat head~1'
git config --global alias.dcnushp 'diff --cached --numstat head~1'

# [show]
## git show [<options>] [<object>…]
## <object>…: defaults to HEAD & https://git-scm.com/docs/gitrevisions for more info
## common usage 1: git show [PATHSPEC]; e.g. git show \*XXxx\*
## common usage 2: git show [<REV>:<PATH>]; e.g. git show origin/master:<path>; note that <PATH> cannot take wildcard char 
git config --global alias.shw 'show'
git config --global alias.lfshw '!sh -c '"\"git ls-files -- '\$2' | xargs -o -I@ git show '\$1':@\" - " # git lfshw <REV> <PATH>; Note that the ls-files makes wildcard char usable

# [reset]
# git reset [--soft | --mixed [-N] | --hard | --merge | --keep] [-q] [<commit>]
# git reset [-q] [<tree-ish>] [--] <pathspec>...
# git reset [-q] [--pathspec-from-file=<file> [--pathspec-file-nul]] [<tree-ish>]
# git reset (--patch | -p) [<tree-ish>] [--] [<pathspec>...]
# This Git command changes, at minimum, HEAD to point to <commit>, which by default is HEAD
# Pls rmb to enclose your argument with quotes or prepend * with \ when declaring <pathspec>; otherwise, * will be firstly expanded by your shell before passing to Git
git config --global alias.rs 'reset' # by default, --mixed, which also changes the index

git config --global alias.rsh 'reset --hard' # also changes the index & the working directory
git config --global alias.rss 'reset --soft'
# More `reset` usage:
# git reset [(--patch | -p)|-q] [<tree-ish>] [--] [<pathspec>] # copy entries from <tree-ish> to the index
# v.s. `checkout`: `checkout` would change the working tree as well

# [restore]
# --source to restore from a diff commit, --staged & --working-tree to specify where to restore to (by default, it's --working-tree)
# specify <pathspec> to choose which files to restore & -p for patch-wise restoration
git config --global alias.rto 'restore'
git config --global alias.rtoso 'restore --source'

# [tag]
## alias naming: <t>[a][m|f]
git config --global alias.t 'tag' # git t [TAGNAME [COMMIT]]; list all tags or create a lightweight tag, which by default points to the current commit
git config --global alias.ta 'tag -a'
git config --global alias.tm '!sh -c '"'git tag \"\$1\" -m \"\$2\"' - " # git tm <TAGNAME> <TAG-MESSAGE>; note that this acutally created an annotated tag but not a lightweight tag
git config --global alias.tf 'tag -f' # git tf <TAGNAME> [COMMIT]; make a tag pointing to another commit, which by default is head
git config --global alias.taf 'tag -af' # move a tag and force-create an annotated tag
## alias naming: <t><l|d>
git config --global alias.tl 'tag -l' # git tl <TAGNAME>; note that <TAGNAME> here takes wildcard chard (quotes or backslash is needed to prevent your shell from expanding it); note that to show more info about the tags, use `git show`
git config --global alias.td 'tag -d' # git td <TAGNAME>; delete tag(s) in the local repository

# [submodule]
git config --global alias.sm 'submodule'
git config --global alias.smuirc 'submodule update --init --recursive'
git config --global alias.smurmrc 'submodule update --remote --merge --recursive'
git config --global alias.sma 'submodule add'
git config --global alias.smsb 'submodule set-branch'
git config --global alias.smsu 'submodule set-url'

# [branch]
## alias naming: <br>[a|r][l|v|vv]
git config --global alias.br 'branch'
git config --global alias.brl 'branch -l'
git config --global alias.brv 'branch -v'
git config --global alias.brvv 'branch -vv'

git config --global alias.bra 'branch -a'
git config --global alias.bral 'branch -al'
git config --global alias.brav 'branch -av'
git config --global alias.bravv 'branch -avvv'

git config --global alias.brr 'branch -r'
git config --global alias.brrl 'branch -rl'
git config --global alias.brrv 'branch -rv'
git config --global alias.brrvv 'branch -rvvv'

## alias naming: <br><f|m|d|dd>
git config --global alias.brf 'branch -f' # change to point to another commit, which by default is the head; git brf <BRANCH-NAME> [<NEW-TIP-COMMIT>];
GIT config --global alias.brm 'branch -m' # rename branch; git brm <NEW-NAME|<OLD-NAME> <NEW-NAME>>;
git config --global alias.brd 'branch -d'
git config --global alias.brdd 'branch -D'

# [clean]
## `clean` removes untracked files from the working tree.
## It is suggested to perform a dry-run first with -n.
## alias naming: <cle>[[d][x|xx][e|esh]|i]
git config --global alias.cle 'clean' # remove non-ignored files
git config --global alias.cled 'clean -d' # also remove directories
git config --global alias.clex 'clean -x' # remove ignored as well as non-ignored files
git config --global alias.clexx 'clean -X' # remove ignored files
git config --global alias.cledx 'clean -d -x'
git config --global alias.cledxx 'clean -d -X'
git config --global alias.clei 'clean -i' # equivalent to --interactive

git config --global alias.clee 'clean -e' # -e, i.e. --exclude (to declare additional ignore rules)
git config --global alias.clede 'clean -d -e'
git config --global alias.clexe 'clean -x -e'
git config --global alias.clexxe 'clean -X -e'
git config --global alias.cledxe 'clean -d -x -e'
git config --global alias.cledxxe 'clean -d -X -e'

git config --global alias.cleesh 'clean -e *.sh -e *.bat'
git config --global alias.cledesh 'clean -d -e *.sh -e *.bat'
git config --global alias.clexesh 'clean -x -e *.sh -e *.bat'
git config --global alias.clexxesh 'clean -X -e *.sh -e *.bat'
git config --global alias.cledxesh 'clean -d -x -e *.sh -e *.bat'
git config --global alias.cledxxesh 'clean -d -X -e *.sh -e *.bat'

# [blame]
git config --global alias.bl 'blame'
git config --global alias.lfbl '!sh -c '"'git ls-files -- '\$1' | xargs git blame' - "

# [apply]
git config --global alias.app 'apply'

# [company's specific need, e.g. set git hooks]
