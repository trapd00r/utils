foo=$(uptime|perl -pe 's/.+up (.+)/$1/')
echo -e "$(date)\b\b\b\b\b\b\t1984: $foo"|pv -L 10 -q
