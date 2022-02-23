#!/bin/zsh

myGitUserName='8ooo8'
myGitUserEmail='ben.cky.workspace@gmail.com'
myEditor='nvim'
myPager='less'

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
git config --global alias.psta 'push --tags'
git config --global alias.psd 'push -d'
git config --global alias.psge '!sh -c '"'git push origin HEAD:refs/for/\"\$1\"' - " # git psge BRANCH-NAME; # this alias pushes to Gerrit and assumed the Gerrit remote branch is named as origin

# [clone]
git config --global alias.clo 'clone'

# [pull]
git config --global alias.pl 'pull'
git config --global alias.plrs 'pull --recurse-submodules'

# [fetch]
git config --global alias.fe 'fetch'

# [remote]
git config --global alias.rem 'remote'
git config --global alias.remv 'remote -v'

# [checkout]
git config --global alias.co 'checkout'
git config --global alias.cof 'checkout -f'
git config --global alias.cofh '!sh -c '"'git checkout -f head\${1} -- \${@:2}' - " # e.g. git cofh \~1 PATH-SPEC; # the alias suffix 'h' means Head
git config --global alias.cofhc '!sh -c '"'git checkout -f head -- \${@:1}' - " # git cofhc PATH-SPEC; # the alias suffix 'c' refers the commit Currently pointed by head
git config --global alias.coph '!sh -c '"'git checkout -p head\${1} -- \${@:2}' - " # e.g. git coph \~1 [PATH-SPEC]
git config --global alias.cophc '!sh -c '"'git checkout -p head -- \${@:1}' - " # git cophc [PATH-SPEC]
git config --global alias.cob 'checkout -b'
git config --global alias.coou 'checkout --ours'
git config --global alias.coth 'checkout --theirs'

# [merge]
git config --global alias.me 'merge'
git config --global alias.mec 'merge --continue'
git config --global alias.mea 'merge --abort'
git config --global alias.meq 'merge --quit'

# [reflog]
git config --global alias.rl 'reflog'
git config --global alias.rld 'reflog --date=relative'

# [commit]
## alias naming: <cm>[a|p][amd|m]
git config --global alias.cm 'commit'
git config --global alias.cmm 'commit -m'
git config --global alias.cmamd 'commit --amend'

git config --global alias.cma 'commit -a'
git config --global alias.cmp 'commit -p' # git cmp [PATHSPEC]

git config --global alias.cmam 'commit -a -m' # git cmam COMMIT-MSG
git config --global alias.cmpm 'commit -p -m' # git cmpm COMMIT-MSG [PATHSPEC]

git config --global alias.cmaamd 'commit -a --amend'
git config --global alias.cmpamd 'commit -p --amend'

# [rebase]
git config --global alias.rb 'rebase'
git config --global alias.rba 'rebase --abort'
git config --global alias.rbc 'rebase --continue'
git config --global alias.rbs 'rebase --skip'
git config --global alias.rbed 'rebase --edit-to'
git config --global alias.rbi 'rebase -i'
git config --global alias.rbir 'rebase -i --root'
## alias 'rbip' example:
## say you have created a branch from master for a hot fix issue and you would like to edit your hot fix commits, `git rbip master` may help
git config --global alias.rbip '!sh -c '"'git rebase -i \"\$1\"~1' - " # rebase on the parent of the specified commit, e.g. on head~1~1 if head~1 is specified; # the alias suffix 'p' refers to the Parent commit of the specified commit
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
git config --global alias.a 'add'
git config --global alias.aa 'add -A'
git config --global alias.au 'add -u'
git config --global alias.ap 'add -p'
git config --global alias.ai 'add -i'
git config --global alias.air 'git add --ignore-removal .'

# [log]
## Basic
## example: say you have created a branch from master for a hot fix issue and you would like to view the commits made for the issue, `git l master..` may help
git config --global alias.l 'log'

## Search across all branches / through current branch for (own) commits by commit messages / committed changes
### usage: git ALIAS COMMIT-MSG-OR-COMMITED-CHANGES
### alias naming: <l>[a|c][o|p|st][r][i][s|ge|gr]
### example: when you would like to read the commit message for a specific line of code, `git las 'THE-LINE-OF-CODE'` may help
### example: say you would like to view all your commits on the current branch, `git lco` may help
### example: say you would like to view your last committed changes, `git lp -1` may help
(
logAliasesPart2=(':' 'a:--all' "c:--committer \"$myGitUserEmail\"")
logAliasesPart3=(':' 'o:--oneline' 'p:-p' 'st:--stat')
logAliasesPart4=(':' 'r:--reverse')
logAliasesPart5=(':' 'i:-i')
logAliasesPart6=(':' 's:-S' 'ge:-G' 'gr:--grep')
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
                    #### usage: git ALIAS COMMIT-POINTER-OR-COMMIT-HASH
                    aliasName="l${p2%:*}${p3%:*}${p4%:*}ph"
                    aliasCmd="${p2#*:} ${p3#*:} ${p4#*:}"
                    aliasCmd="\"git log ${aliasCmd} \${1}~1..head\"" # PARENT-OF-SPECIFIED-COMMIT..head instead of SPECIFIED-COMMIT..head to include the specified commit in the log view
                    aliasCmd='!sh -c '"${aliasCmd}"' - '
                    sh -c "git config --global alias.${aliasName} '${aliasCmd}'"
                else
                    #### alias naming: <l>[c][o|p|st][r][i]<s|ge|gr><ph>
                    #### usage: git ALIAS COMMIT-MSG-OR-COMMITTED-CHNAGES
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
### usage: git ALIAS COMMIT-MSG
git config --global alias.lcgrrbp '!sh -c '"'git log --committer \"$myGitUserEmail\" --pretty=\"%h\" --grep \"\$1\" -1 | xargs -o -I@ git rebase -i @~1' - " # rebase on the parent of the 1st search result. it will fail if no such parent.
git config --global alias.lcigrrbp '!sh -c '"'git log --committer \"$myGitUserEmail\" --pretty=\"%h\" -i --grep \"\$1\" -1 | xargs -o -I@ git rebase -i @~1' - " # rebase on the parent of the 1st search result. it will fail if no such parent.
### usage: git log ... | git ALIAS
git config --global alias.awkrbip '!sh -c '"\"awk 'NR=1{print \\\$1}' | xargs -o -I{} git rebase -i {}~1\"" # crop the commit hash from the 1st line of previous git command output and rebase on its parent. it will fail if no such parent.

## Graph
git config --global alias.laog 'log --graph --oneline --all'

# [status]
git config --global alias.stt 'status'
git config --global alias.sttun 'status -uno' # do not show the untracked files
git config --global alias.sttua 'status -uall'
git config --global alias.sttv 'status -v'

# [stash]
## push
## alias naming: <sts> or <stsps>[u|a][k][m]
stashPushAlias='stsps'
sh -c "git config --global alias.${stashPushAlias} 'stash'"
git config --global alias.sts 'stash' # shorthand alternative for stash push
sh -c "git config --global alias.${stashPushAlias}m 'stash -m'"
sh -c "git config --global alias.${stashPushAlias}k 'stash -k'" # -k, i.e. --keep-index (All changes already added to the index are left intact)
sh -c "git config --global alias.${stashPushAlias}km 'stash -k -m'"

sh -c "git config --global alias.${stashPushAlias}u 'stash -u'" # -u, i.e. --include-untracked
sh -c "git config --global alias.${stashPushAlias}um 'stash -u -m'"
sh -c "git config --global alias.${stashPushAlias}uk 'stash -u -k'"
sh -c "git config --global alias.${stashPushAlias}ukm 'stash -u -k -m'"

sh -c "git config --global alias.${stashPushAlias}a 'stash -a'" # -a, i.e. --all (tracked, untracked and ignored files are all put into the stash)
sh -c "git config --global alias.${stashPushAlias}am 'stash -a -m'"
sh -c "git config --global alias.${stashPushAlias}ak 'stash -a -k'"
sh -c "git config --global alias.${stashPushAlias}akm 'stash -a -k -m'"

## list
git config --global alias.stsl 'stash list'
git config --global alias.stslb 'stash list --before'
git config --global alias.stsla 'stash list --after'
git config --global alias.stslp 'stash list -p' # note that it does not show the untracked files

## apply
git config --global alias.stsa 'stash apply'
git config --global alias.stsai 'stash apply --index' # --index tries to also reinstate the index

## show
git config --global alias.stssh 'stash show'
git config --global alias.stsshu 'stash show -u' # -u, i.e. --include-untracked
git config --global alias.stsshp 'stash show -p'
git config --global alias.stsshpu 'stash show -p -u'

## pop, drop, clear
git config --global alias.stspo 'stash pop'
git config --global alias.stsd 'stash drop'
git config --global alias.stsc 'stash clear'

## Checkout specific file(s) in a specific stash entry
git config --global alias.stscoff '!sh -c '"'git checkout -f stash@{\$1:-0} -- \${@:2}' - " # git stscoff STASH-ENTRY-NUMBER PATHSPEC; # defailt stash@{0}
git config --global alias.stscopf '!sh -c '"'git checkout -p stash@{\$1:-0} -- \${@:2}' - " # git stscopf STASH-ENTRY-NUMBER [PATHSPEC]; # default stash@{0}

## stash > stash apply
git config --global alias.sts-aiq '!sh -c '"'git ${stashPushAlias}\"\$@\" && git stash apply --index -q' - " # git sts-aiq [SUFFIX-TO-FORM-STASH-PUSH-ALIAS [ARGUMENTS-TO-STASH-PUSH]]

## reset --hard > stash apply
git config --global alias.rshqstsai '!sh -c '"'git reset --hard -q && git stash apply --index \"\${1:-0}\"' - " # git rshqstsa STASH-ENTRY; # default stash@{0}

# [rm]
git config --global alias.rmc 'rm --cached'

# [diff]
## suggested to call below aliases to check your change before making a new commit or amending your previous commit, especially when there is time-consuming git-hook work for commit
## alias naming: <d>[c][nus][h|hp]
git config --global alias.d 'diff'
git config --global alias.dc 'diff --cached'
git config --global alias.dh 'diff head'
git config --global alias.dch 'diff --cached head'
git config --global alias.dhp 'diff head~1'
git config --global alias.dchp 'diff --cached head~1'

git config --global alias.dnus 'diff --numstat'
git config --global alias.dcnus 'diff --cached --numstat'
git config --global alias.dnush 'diff --numstat head'
git config --global alias.dcnush 'diff --cached --numstat head'
git config --global alias.dnushp 'diff --numstat head~1'
git config --global alias.dcnushp 'diff --cached --numstat head~1'

# [show]
git config --global alias.shw 'show'
git config --global alias.lfshw '!sh -c '"\"git ls-files -- '\$2' | xargs -o -I@ git show '\$1':@\" - " # git shw COMMIT FILE

# [reset]
git config --global alias.rs 'reset' # pls rmb to enclose your argument with quotes or prepend * with \; otherwise, * will be firstly expanded by your shell before passing to Git

git config --global alias.rsh 'reset --hard'
git config --global alias.rss 'reset --soft'

# [reset]
git config --global alias.rto 'restore'

# [tag]
# making a good use of tag would allow a quick Git operation, e.g. git rbip TAG-OF-MY-EARLIEST-COMMIT-FOR-CURRENT-TASK
git config --global alias.t 'tag'
git config --global alias.ta 'tag -a'
git config --global alias.tam '!sh -c '"'git tag -a \"\$1\" -m \"\$2\"' - "
git config --global alias.tl 'tag -l' # pls rmb to enclose your argument with quotes or prepend * with \; otherwise, * will be firstly expanded by your shell before passing to Git
git config --global alias.tf 'tag -f'
git config --global alias.td 'tag -d'

# [submodule]
git config --global alias.sm 'submodule'
git config --global alias.smui 'submodule update --init'

# [branch]
## alias naming: <br>[a][l|v|vv]
git config --global alias.br 'branch'
git config --global alias.brl 'branch -l'
git config --global alias.brv 'branch -v'
git config --global alias.brvv 'branch -vv'

git config --global alias.bra 'branch -a'
git config --global alias.bral 'branch -al'
git config --global alias.brav 'branch -av'
git config --global alias.bravv 'branch -avvv'

## alias naming: <br><f|m|d|dd>
git config --global alias.brf 'branch -f' # change to point to another commit; git brf <BRANCH-NAME> [<NEW-TIP-COMMIT>];
GIT config --global alias.brm 'branch -m' # rename branch; git brm <NEW-NAME|<OLD-NAME> <NEW-NAME>>;
git config --global alias.brd 'branch -d'
git config --global alias.brdd 'branch -D'

# [clean]
## It is suggested to perform a dry-run first with -n
## alias naming: <cle>[[d][x|xx][e|esh]|i]
git config --global alias.cle 'clean' # remove non-ignored files
git config --global alias.cled 'clean -d' # also remove directories
git config --global alias.clex 'clean -x' # remove ignored as well as non-ignored files
git config --global alias.clexx 'clean -X' # remove ignored files
git config --global alias.cledx 'clean -d -x'
git config --global alias.cledxx 'clean -d -X'
git config --global alias.clei 'clean -i'

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
