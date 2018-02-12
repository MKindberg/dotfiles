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
