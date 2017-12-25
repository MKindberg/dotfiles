# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
shopt -s cdspell

# Completion options
bind '"\t": menu-complete'
bind '"\e[Z": menu-complete-backward'
set show-all-if-ambiguous on

# History Options
#
# Don't put duplicate lines in the history.
#
# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.

# Functions
if [ -f "${HOME}/.bash_functions" ]; then
  source "${HOME}/.bash_functions"
fi

# Variables
if [ -f "${HOME}/.bash_variables" ]; then
  source "${HOME}/.bash_variables"
fi

# Aliases
if [ -f "${HOME}/.bash_aliases" ]; then
  source "${HOME}/.bash_aliases"
fi
