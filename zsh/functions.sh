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
  if [[ $FZF_PREVIEW == 0 ]]; then
    commit=$(echo "$commits" | fzf --tac +s +m -e ) &&
  else
    commit=$(echo "$commits" | fzf --tac +s +m -e --preview 'git show {+1}') &&
  fi
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
  local files entries cmd
  file=$1
  entries=$(git log --pretty=oneline --abbrev-commit)
  if [[ $FZF_PREVIEW == 0 ]]; then
    echo $entries | fzf | git checkout
  else
    cmd='git diff --color=always {+1} '"$file"
    echo $entries | fzf --preview $cmd | git checkout
  fi
}
function ga {
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

function gd {
  if [[ $FZF_PREVIEW == 0 ]]; then
    git diff --color=always $@
  else
    local files cmd
    cmd="git diff --color=always $@ {} "
    if [ $# -eq 0 ]; then
      files=$(git ls-files -m -o --exclude-standard -x "*")
    else
      files=$(git log --name-only --pretty=oneline --full-index $1..HEAD | grep -vE '^[0-9a-f]{40} ' | sort | uniq)
    fi
    file=" "
    while [ $file ]; do
      file=$(echo "$files" | fzf -0 --preview $cmd)
      if [ $file ]; then
        vim ${file}
      fi
    done
  fi
}

function glo {
  local entries
  entries=$(git log --pretty=oneline --abbrev-commit)
  cmd='git show --color=always {+1}'
  if [[ $FZF_PREVIEW == 0 ]]; then
    echo $entries | fzf --bind="enter:execute($cmd)"
  else
    echo $entries | fzf --preview $cmd
  fi
}

function gsh {
  local rev="HEAD"
  if [[ $# > 0 ]]; then
    rev=$1
  fi

  file=" "
  while [ $file ]; do
    file=$(git show --format=oneline --name-only ${rev} | fzf --preview "git diff --color ${rev}~1 $rev {}")
    if [ $file ]; then
      vim ${file}
    fi
  done
}

function ggg {
  local file=$(git grep -l $1 | fzf --preview "git grep --color -A 5 -B 5 $1 -- {}")
  while [[ $file ]]; do
    vim -o $file
    local file=$(git grep -l $1 | fzf --preview "git grep --color -A 5 -B 5 $1 -- {}")
  done
}

function nvim {
  local cmd
  local nvim=$(whence -p nvim)
  for arg in $@; do
    cmd="$cmd \"${arg/:/\" \"+:}\""
  done
  if [ $nvim ]; then
    eval $nvim $cmd
  else
    eval vim $cmd
  fi
}
