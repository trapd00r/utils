#!/bin/zsh

if [[ $HOST = 'shiva' ]]; then
  /bin/zsh -c "source /home/scp1/etc/zsh/zshrc; /bin/zsh" "$@"
else if [[ $HOST = 'rambo' ]]; then
  /bin/zsh -c "source /home/scp1/.zshrc; /bin/zsh"
fi
