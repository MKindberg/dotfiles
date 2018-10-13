# Bash functions
function up {
  export back=$PWD
  newDir=$PWD
  for (( c=0; c<$1; c++ ))
  do
    newDir=$newDir/..
  done
  cd $newDir
}

function back {
  cd $back
}

function cdd () {
    cd $1
    ls
}

function PS1_pscount {
  ps -a | wc -l
}

fbr() { #checkout local branch
  local branches branch
  branches=$(git branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

gor() { #checkout remote brach or tag
  local tags branches target
  tags=$(
    git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
  branches=$(
    git branch --all | grep -v HEAD             |
    sed "s/.* //"    | sed "s#remotes/[^/]*/##" |
    sort -u          | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  target=$(
    (echo "$tags"; echo "$branches") |
    fzf-tmux -l30 -- --no-hscroll --ansi +m -d "\t" -n 2) || return
  git checkout $(echo "$target" | awk '{print $2}')
}

goc() { #checkout commit
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e --preview 'git show {+1}') &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}

function go {
  if [ $# -eq 0 ]; then
    fbr
  else
    git checkout "$@"
  fi
}
function gof {
  local file=$1
  local entries=$(git log --pretty=oneline --abbrev-commit)
  local cmd='git diff --color=always {+1} '"$file"
  echo $entries | fzf --preview $cmd | git checkout
}
function ga {
  if [ $# -eq 0 ]; then
    local files=$(git ls-files -m -o --exclude-standard -x "*" | fzf -m -0 --preview 'git diff --color=always {}')
    [[ -n "$files" ]] && echo "$files" | xargs -I{} git add {} && git status --short --ignored=no --untracked=no
  else
    git add "$@"
  fi
}

function gd {
  local files=""
  if [ $# -eq 0 ]; then
    files=$(git ls-files -m -o --exclude-standard -x "*")
  else
    files=$(git log --name-only --pretty=oneline --full-index $1..HEAD | grep -vE '^[0-9a-f]{40} ' | sort | uniq)
  fi
  local cmd="git diff --color=always $@ {} "
  echo "$files" | fzf -0 --preview $cmd --bind="enter:execute($cmd)"
}

function glo {
  local entries=$(git log --pretty=oneline --abbrev-commit)
  echo $entries | fzf --preview 'git show --color=always {+1}'
}
