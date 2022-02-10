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
git config --global alias.remv 'remote -v'

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
git config --global alias.air 'git add --ignore-removal .'

# [log]
## Basic
git config --global alias.l 'log'
git config --global alias.lp 'log -p'

## Search across all branches
### alias naming: <la>[o|p|st][r]<s|ge|gr>[i]
#### -S 
git config --global alias.las 'log --all -S'
git config --global alias.lars 'log --all --reverse -S'

git config --global alias.lasi 'log --all -i -S' # -i
git config --global alias.larsi 'log --all --reverse -i -S'

git config --global alias.laos 'log --oneline --all -S' # --oneline
git config --global alias.laors 'log --oneline --all --reverse -S'

git config --global alias.laosi 'log --oneline --all -i -S' # --oneline -i
git config --global alias.laorsi 'log --oneline --all --reverse -i -S'

git config --global alias.laps 'log -p --all -S' # -p
git config --global alias.laprs 'log -p --all --reverse -S'

git config --global alias.lapsi 'log -p --all -i -S' # -p -i
git config --global alias.laprsi 'log -p --all --reverse -i -S'

git config --global alias.lasts 'log --stat --all -S' # --stat
git config --global alias.lastrs 'log -stat --all --reverse -S'

git config --global alias.lastsi 'log --stat --all -i -S' # --stat -i
git config --global alias.lastrsi 'log --stat --all --reverse -i -S'

#### -G
git config --global alias.lage 'log --all -G' # 'ge' in the alias name refers to the -G option (reGEx)
git config --global alias.large 'log --all --reverse -G'

git config --global alias.lagei 'log --all -i -G' # -i
git config --global alias.largei 'log --all --reverse -i -G'

git config --global alias.laoge 'log --oneline --all -G' # --oneline
git config --global alias.laorge 'log --oneline --all --reverse -G'

git config --global alias.laogei 'log --oneline --all -i -G' # --oneline -i
git config --global alias.laorgei 'log --oneline --all --reverse -i -G'

git config --global alias.lapge 'log -p --all -G' # -p
git config --global alias.laprge 'log -p --all --reverse -G'

git config --global alias.lapgei 'log -p --all -i -G' # -p -i
git config --global alias.laprgei 'log -p --all --reverse -i -G'

git config --global alias.lastge 'log --stat --all -G' # --stat
git config --global alias.lastrge 'log --stat --all --reverse -G'

git config --global alias.lastgei 'log --stat --all -i -G' # --stat -i
git config --global alias.lastrgei 'log --stat --all --reverse -i -G'

#### --grep
git config --global alias.lagr 'log --all --grep'
git config --global alias.largr 'log --all --reverse --grep'

git config --global alias.lagri 'log --all -i --grep' # -i
git config --global alias.largri 'log --all --reverse -i --grep'

git config --global alias.laogr 'log --oneline --all --grep' # --oneline
git config --global alias.laorgr 'log --oneline --all --reverse --grep'

git config --global alias.laogri 'log --oneline --all -i --grep' # --oneline -i
git config --global alias.laorgri 'log --oneline --all --reverse -i --grep'

git config --global alias.lapgr 'log -p --all --grep' # -p
git config --global alias.laprgr 'log -p --all --reverse --grep'

git config --global alias.lapgri 'log -p --all -i --grep' # -p -i
git config --global alias.laprgri 'log -p --all --reverse -i --grep'

git config --global alias.lastgr 'log --stat --all --grep' # --stat
git config --global alias.lastrgr 'log -stat --all --reverse --grep'

git config --global alias.lastgri 'log --stat --all -i --grep' # --stat -i
git config --global alias.lastrgri 'log --stat --all --reverse -i --grep'

## Graph
git config --global alias.laog 'log --graph --oneline --all'

## Search for/list own commits through current working branch
git config --global alias.lc "log --committer '$myGitUserEmail'"
git config --global alias.lco "log --committer '$myGitUserEmail' --oneline"
git config --global alias.lcor "log --committer '$myGitUserEmail' --oneline --reverse"
git config --global alias.lcogr "log --committer '$myGitUserEmail' --oneline --grep"
git config --global alias.lcogri "log --committer '$myGitUserEmail' --oneline -i --grep"
git config --global alias.lcos "log --committer '$myGitUserEmail' --oneline -S"
git config --global alias.lcosi "log --committer '$myGitUserEmail' --oneline -i -S"
git config --global alias.lcoge "log --committer '$myGitUserEmail' --oneline -G"
git config --global alias.lcogei "log --committer '$myGitUserEmail' --oneline -i -G"
git config --global alias.lcogrh "log --committer '$myGitUserEmail' --oneline --pretty='%h' --grep" # to get the commit hash for further git operation, e.g. rebase; the alias suffix 'h' means Hash;
git config --global alias.lcogrih "log --committer '$myGitUserEmail' --oneline --pretty='%h' -i --grep" # to get the commit hash
git config --global alias.lcosh "log --committer '$myGitUserEmail' --oneline --pretty='%h' -S" # to get the commit hash
git config --global alias.lcosih "log --committer '$myGitUserEmail' --oneline --pretty='%h' -i -S" # to get the commit hash
git config --global alias.lcogeh "log --committer '$myGitUserEmail' --oneline --pretty='%h' -G" # to get the commit hash
git config --global alias.lcogeih "log --committer '$myGitUserEmail' --oneline --pretty='%h' -i -G" # to get the commit hash

## Search for/list own commits and display the details through current working branch
git config --global alias.lcst "log --committer '$myGitUserEmail' --stat"
git config --global alias.lcp "log --committer '$myGitUserEmail' -p" # extra info: to view the last commit changes only, git lcp -1
git config --global alias.lcpr "log --committer '$myGitUserEmail' --reverse -p"
git config --global alias.lcprgrp '!sh -c '"'git log --committer \"$myGitUserEmail\" --pretty=\"%h\" --grep \"\$1\" | xargs -o -I@ git log --reverse -p @~1..HEAD' - "
git config --global alias.lcprgrip '!sh -c '"'git log --committer \"$myGitUserEmail\" --pretty=\"%h\" -i --grep \"\$1\" | xargs -o -I@ git log --reverse -p @~1..HEAD' - "

## Search for own commit through current working branch and then rebase on its parent
git config --global alias.lcrb '!sh -c '"'git rebase -i \$(git log --committer \"$myGitUserEmail\" --oneline --reverse --pretty=\"%h\" | head -1)~1'" # rebase on the parent of your earliest commit on the current branch. it will fail if no such parent.
git config --global alias.lcgrrb '!sh -c '"'git log --committer \"$myGitUserEmail\" --pretty=\"%h\" --grep \"\$1\" | xargs -o -I@ git rebase -i @~1' - " # rebase on the parent of the search result. it will fail if no such parent.
git config --global alias.lcgrirb '!sh -c '"'git log --committer \"$myGitUserEmail\" --pretty=\"%h\" -i --grep \"\$1\" | xargs -o -I@ git rebase -i @~1' - " # rebase on the parent of the search result. it will fail if no such parent.
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
git config --global alias.bra 'branch -a'
git config --global alias.brf 'branch -f'
git config --global alias.brl 'branch -l'
git config --global alias.brv 'branch -v'
git config --global alias.brvv 'branch -vv'
git config --global alias.bral 'branch -al'
git config --global alias.brav 'branch -av'
git config --global alias.bravv 'branch -avvv'
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
