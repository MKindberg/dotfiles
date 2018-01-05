# Bash functions
function up {
  export back=$PWD

  for i in {1..$1}
  do
    cd ..
  done
}

function back {
  cd $back
}

function pscount {
  ps -a | wc -l
}
