#!/bin/zsh

if [[ $HOST = 'shiva' ]]; then
  /bin/zsh -c "source /home/scp1/etc/zsh/zshrc; /bin/zsh" "$@"
elif [[ $HOST = 'rambo' ]]; then
  /bin/zsh -c "source /home/scp1/.zshrc; /bin/zsh"
fi
