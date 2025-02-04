ls *.sh | fzf --preview 'bat --style=numbers --color=always --line-range=:10 {}' | xargs -I {} bash {}
