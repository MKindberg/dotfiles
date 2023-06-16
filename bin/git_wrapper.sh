#!/bin/bash

git_checkout_remote() {
    local tags branches target
    tags=$(
        git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
    branches=$(
        git branch --all | grep -v HEAD             |
        sed "s/.* //"    | sed "s#remotes/[^/]*/##" |
        sort -u          | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
    target=$(
        (echo "$tags"; echo "$branches") |
        fzf-tmux -l30 -- --no-hscroll --ansi +m -d "\t" -n 2 --preview='') || return
    target=$(echo "$target" | awk '{print $2}')
    git checkout "$target"
}

git_checkout_commit() {
    local commits commit
    commits=$(git log --pretty=oneline --abbrev-commit --reverse)
    if [[ $FZF_PREVIEW == 0 ]]; then
        commit=$(echo "$commits" | fzf --tac +s +m -e )
    else
        commit=$(echo "$commits" | fzf --tac +s +m -e --preview 'git show {+1}' | cut -f 1 -d ' ')
    fi
    git checkout "$commit"
}

git_checkout_branch() {
    if [ $# -eq 0 ]; then
        local branches branch
        branches=$(git branch -vv) &&
            branch=$(echo "$branches" | fzf +m --preview='git log --color=always --oneline $(echo {} | cut -d " " -f 3)' | cut -d ' ' -f 3) &&
            git checkout "$branch"
    else
        git checkout "$@"
    fi
}

git_add() {
    local files
    if [ $# -eq 0 ]; then
        if [[ $FZF_PREVIEW == 0 ]]; then
            files=$(git ls-files -m -o --exclude-standard -x "*" | fzf -m -0 )
        else
            files=$(git ls-files -m -o --exclude-standard -x "*" | fzf -m -0 --preview 'git diff --color=always {}')
        fi
        [[ -n "$files" ]] && echo "$files" | xargs -I{} git add {} && git status --short --untracked=no
    else
        git add "$@"
    fi
}

git_diff() {
    if command -v tig &> /dev/null && [[ -z "$*" ]]; then
        tig status
    elif [[ $FZF_PREVIEW == 0 ]]; then
        git diff --color=always "$@"
    else
        local files cmd
        cmd="git diff --color=always $* {} | diff-so-fancy"
        if [ $# -eq 0 ]; then
            files=$(git ls-files -m -o --exclude-standard -x "*")
        else
            files=$(git log --name-only --pretty=oneline --full-index "$1..HEAD" | grep -vE '^[0-9a-f]{40} ' | sort | uniq)
        fi
        echo "$files" | fzf -0 --preview "$cmd" --bind "enter:execute($EDITOR {})"
    fi
}

git_log() {
    local entries
    entries=$(git log --pretty=oneline --abbrev-commit)
    cmd='git show --color=always {+1}'
    if [[ $FZF_PREVIEW == 0 ]]; then
        echo "$entries" | fzf --bind="enter:execute($cmd)"
    else
        echo "$entries" | fzf --preview "$cmd"
    fi
}

git_show() {
    local rev="HEAD"
    if [[ $# -gt 0 ]]; then
        rev=$1
    fi
    file=$(git show --format=oneline --name-only "$rev" | fzf --preview "git diff --color=always ${rev}~1 $rev {} | diff-so-fancy" --bind "enter:execute($EDITOR {})")
}

git_grep() {
    if [[ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" == "true" ]]; then
        tig grep "$@"
    elif [[ -d .repo ]]; then
        repo grep "$@" | grep_tui
    else
        rg --no-heading -n "$@" | grep_tui
    fi
}

git_show_stash() {
    # shellcheck disable=SC2016
    git stash list | fzf --preview 'git show $(echo {} | cut -f 1 -d :)'
}

case $(basename "$0") in
    ga)
        git_add "$@"
        ;;
    gd)
        git_diff "$@"
        ;;
    gg)
        git_grep "$@"
        ;;
    gl)
        git_log "$@"
        ;;
    go)
        git_checkout_branch "$@"
        ;;
    goc)
        git_checkout_commit "$@"
        ;;
    gor)
        git_checkout_remote "$@"
        ;;
    gsh)
        git_show "$@"
        ;;
    gshs)
        git_show_stash "$@"
        ;;
esac
