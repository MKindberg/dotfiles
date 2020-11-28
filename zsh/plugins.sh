if [[ $ZSH_VERSION -ge 5.3 ]]; then
  zinit ice pick"zsh-autocomplete.plugin.zsh"
  zinit light marlonrichert/zsh-autocomplete

  TURBO=wait'!0'

fi

  zinit ice pick"zsh-syntax-highlighting.zsh" $TURBO
  zinit light zsh-users/zsh-syntax-highlighting

  zinit ice pick"zsh-autosuggestions.zsh" $TURBO
  zinit light zsh-users/zsh-autosuggestions
