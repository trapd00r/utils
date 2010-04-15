#!/bin/sh
rm -r $(for x in /mnt/Music_{1,2,3,5,6,7};do for a in {A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,VA,X,Y,Z}; do diff -i /mnt/Music_6/$a $x/$a; done|grep -v Only|awk '{print $3}'; done)

