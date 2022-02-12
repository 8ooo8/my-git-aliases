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

# [config]
git config --global alias.cf 'config'
git config --global alias.cfl 'config --list'
git config --global alias.cfg 'config --global'
git config --global alias.cfgl 'config --global --list'

# [push]
git config --global alias.ps 'push'
git config --global alias.psu 'push -u'
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
git config --global alias.rev 'remote -v'

# [checkout]
git config --global alias.co 'checkout'
git config --global alias.cof 'checkout -f'
git config --global alias.cofh '!sh -c '"'git checkout -f head\${1} \${@:2}' - " # e.g. git cofh \~1 PATH-SPEC; # the alias suffix 'h' means Head
git config --global alias.cofhc '!sh -c '"'git checkout -f head \${@:1}' - " # git cofhc PATH-SPEC; # the alias suffix 'c' refers the commit Currently pointed by head
git config --global alias.cob 'checkout -b'


# [reflog]
git config --global alias.rl 'reflog'
git config --global alias.rld 'reflog --date=relative'

# [commit]
git config --global alias.cm 'commit'
git config --global alias.cmm 'commit -m'
git config --global alias.cma 'commit --amend'

# [rebase]
git config --global alias.rb 'rebase'
git config --global alias.rba 'rebase --abort'
git config --global alias.rbc 'rebase --continue'
git config --global alias.rbs 'rebase --skip'
git config --global alias.rbed 'rebase --edit-to'
git config --global alias.rbi 'rebase -i'
git config --global alias.rbir 'rebase -i --root'
git config --global alias.rbip '!sh -c '"'git rebase -i \"\$1\"~1' - " # rebase on the parent of the specified commit, e.g. on head~1~1 if head~1 is specified; # the alias suffix 'p' refers to the Parent commit of the specified commit
git config --global alias.rbihp '!sh -c '"'git rebase -i head\"\$1\"~1' - " # rebase on the parent of the specified commit, e.g. on head~2~1 if \~1 is specified

# [cherry-pick]
git config --global alias.cp 'cherry-pick'
git config --global alias.cpa 'cherry-pick --abort'
git config --global alias.cpc 'cherry-pick --continue'

# [revert]
git config --global alias.rvt 'revert'
git config --global alias.rvta 'revert --abort'
git config --global alias.rvtc 'revert --continue'
git config --global alias.rvts 'revert --skip'

# [add]
git config --global alias.a 'add'
git config --global alias.aa 'add -A'
git config --global alias.au 'add -u'
git config --global alias.ai 'add -i'
git config --global alias.air 'git add --ignore-removal .'

# [log]
## Basic
git config --global alias.l 'log'
git config --global alias.lp 'log -p'
git config --global alias.lo 'log -o'
git config --global alias.lst 'log --stat'

## Search across all branches / (own commits) through current branch by commit messages / commit changes
### alias naming: <l>[a|c][o|p|st][r][i][s|ge|gr]
logAliasesPart1=(':' 'a:--all' "c:--committer \"$myGitUserEmail\"")
logAliasesPart2=(':' 'o:--oneline' 'p:-p' 'st:--stat')
logAliasesPart3=(':' 'r:--reverse')
logAliasesPart4=(':' 'i:-i')
logAliasesPart5=(':' 's:-S' 'ge:-G' 'gr:--grep')
for p1 in $logAliasesPart1
do
    for p2 in $logAliasesPart2
    do
        for p3 in $logAliasesPart3
        do
            for p4 in $logAliasesPart4
                do
                for p5 in $logAliasesPart5
                do
                    aliasName="l${p1%:*}${p2%:*}${p3%:*}${p4%:*}${p5%:*}"
                    aliasCmd="log ${p1#*:} ${p2#*:} ${p3#*:} ${p4#*:} ${p5#*:}"
                    sh -c "git config --global alias.${aliasName} '$(echo -e $aliasCmd | awk '{$1=$1}1')'"
                done
            done
        done
    done
done

## Graph
git config --global alias.laog 'log --graph --oneline --all'

## Show own recent commits since a specific commit in chronological order
git config --global alias.lcprgrp '!sh -c '"'git log --committer \"$myGitUserEmail\" --pretty=\"%h\" --grep \"\$1\" | xargs -o -I@ git log --reverse -p @~1..HEAD' - " # git lcprgrp EARLIEST-COMMIT(YOURS)-IN-THIS-VIEW
git config --global alias.lcprigrp '!sh -c '"'git log --committer \"$myGitUserEmail\" --pretty=\"%h\" -i --grep \"\$1\" | xargs -o -I@ git log --reverse -p @~1..HEAD' - " # git lcprigrp EARLIEST-COMMIT(YOURS)-IN-THIS-VIEW

## rebase to modify own commits
git config --global alias.lcrb '!sh -c '"'git rebase -i \$(git log --committer \"$myGitUserEmail\" --oneline --reverse --pretty=\"%h\" | head -1)~1'" # rebase on the parent of your earliest commit on the current branch. it will fail if no such parent.
git config --global alias.lcgrrb '!sh -c '"'git log --committer \"$myGitUserEmail\" --pretty=\"%h\" --grep \"\$1\" | xargs -o -I@ git rebase -i @~1' - " # rebase on the parent of the search result. it will fail if no such parent.
git config --global alias.lcigrrb '!sh -c '"'git log --committer \"$myGitUserEmail\" --pretty=\"%h\" -i --grep \"\$1\" | xargs -o -I@ git rebase -i @~1' - " # rebase on the parent of the search result. it will fail if no such parent.
git config --global alias.awkrbip '!sh -c '"\"awk '{print \\\$1}' | xargs -o -I{} git rebase -i {}~1\"" # crop the commit hash from commands like `git log --oneline --grep xxx` and then rebase on its parent. it will fail if no such parent.

# [status]
git config --global alias.stt 'status'
git config --global alias.sttv 'status -v'

# [stash]
## push
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
git config --global alias.stscoff '!sh -c '"'git checkout -f stash@{\$1} \${@:2}' - " # git stscoff STASH-ENTRY-NUMBER FILEPATH

## stash > stash apply
git config --global alias.sts-aiq '!sh -c '"'git ${stashPushAlias}\"\$@\" && git stash apply --index -q' - " # git sts-aiq [SUFFIX-TO-FORM-STASH-PUSH-ALIAS [ARGUMENTS-TO-STASH-PUSH]]

## reset --hard > stash apply
git config --global alias.rshqstsai '!sh -c '"'git reset --hard -q && git stash apply --index \"\${1:-0}\"' - " # git rshqstsa STASH-ENTRY; # default stash@{0}

# [rm]
git config --global alias.rmc 'rm --cached'

# [diff]
git config --global alias.d 'diff'
git config --global alias.dc 'diff --cached'

# [show]
git config --global alias.shw 'show'
git config --global alias.shwcf '!sh -c '"\"find . | grep -E '\$2' | xargs -o -I@ git show '\$1':@\" - " # git shw COMMIT FILEPATH-IN-REGEX; # 'c' in the alias name means Commit and 'f' means Filepaths

# [reset]
git config --global alias.rs 'reset'
git config --global alias.rsh 'reset --hard'
git config --global alias.rss 'reset --soft'

# [reset]
git config --global alias.rto 'restore'

# [submodule]
git config --global alias.sm 'submodule'
git config --global alias.smui 'submodule update --init'

# [branch]
git config --global alias.br 'branch'

git config --global alias.brl 'branch -l'
git config --global alias.brv 'branch -v'
git config --global alias.brvv 'branch -vv'

git config --global alias.bra 'branch -a'
git config --global alias.bral 'branch -al'
git config --global alias.brav 'branch -av'
git config --global alias.bravv 'branch -avvv'

git config --global alias.brf 'branch -f'
git config --global alias.brm 'branch -m'
git config --global alias.brd 'branch -d'
git config --global alias.brdd 'branch -D'

# [clean]
# It is suggested to perform a dry-run first with -n
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

# [company's specific need, e.g. set git hooks]
