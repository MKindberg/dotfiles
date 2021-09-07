#!/bin/bash

notes() {
  if [[ -z "$EDITOR" ]]; then
    EDITOR=vim
  fi

  if [[ -z "$NOTES_DIR" ]]; then
    NOTES_DIR=~/notes
  fi

  if [[ ! -d "$NOTES_DIR" ]]; then
    mkdir $NOTES_DIR
  fi

  if [[ "$#" -eq 0 ]]; then
    if [[ -x "$(command -v fzf)" ]]; then
      ls $NOTES_DIR | fzf
    else
      $EDITOR $NOTES_DIR
    fi
  elif [[ "$#" -eq 1 ]]; then
    $EDITOR ${NOTES_DIR}/${1}
  elif [[ "$1" == "d" ]]; then # Delete
    rm -f ${NOTES_DIR}/${2}
  elif [[ "$1" == "r" ]]; then # Read
    cat $2
  elif [[ "$1" == "a" ]]; then # Append
    shift
    FILE=$1
    shift
    echo "$@"
    echo "$@" >> ${NOTES_DIR}/$FILE
  elif [[ "$1" == "s" ]]; then # Search
    grep "^$3" ${NOTES_DIR}/$2
  fi
}
