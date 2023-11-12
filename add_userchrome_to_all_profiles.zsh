#!/usr/bin/zsh
# abstract: copies userChrome.css to all profiles in Firefox
for x in ${HOME}/.mozilla/firefox/*.*/chrome(/); do cp -v ${HOME}/dev/utils/userChrome.css ${x}/userChrome.css; done
