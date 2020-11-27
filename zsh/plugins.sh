if [[ $ZSH_VERSION -ge 5.3 ]]; then

  zinit ice pick"zsh-syntax-highlighting.zsh" wait'!0'
  zinit light zsh-users/zsh-syntax-highlighting

  zinit ice pick"zsh-autosuggestions.zsh" wait'!0'
  zinit light zsh-users/zsh-autosuggestions

  zinit ice pick"zsh-autocomplete.plugin.zsh" wait'!0'
  zinit light marlonrichert/zsh-autocomplete

else

  zinit ice pick"zsh-syntax-highlighting.zsh"
  zinit light zsh-users/zsh-syntax-highlighting

  zinit ice pick"zsh-autosuggestions.zsh"
  zinit light zsh-users/zsh-autosuggestions
fi
