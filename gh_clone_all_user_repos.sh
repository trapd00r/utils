CNTX='users'; NAME='trapd00r';

for PAGE in {1..3}; do 
  curl -s "https://api.github.com/$CNTX/$NAME/repos?page=$PAGE&per_page=100" |
    grep -e 'git_url*' |
    cut -d \" -f 4 ;
  done
