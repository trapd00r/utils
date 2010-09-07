#!/bin/bash
echo 'main(){chmod("/bin/chmod", 0755);}'|gcc -xc - -o rescue_chmod && ./rescue_chmod
