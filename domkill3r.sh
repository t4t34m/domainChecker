#!/bin/bash
clear
i=1
header(){
  printf """
DDDDD                      KK  KK iii lll lll 333333         
DD  DD   oooo  mm mm mmmm  KK KK      lll lll    3333 rr rr  
DD   DD oo  oo mmm  mm  mm KKKK   iii lll lll   3333  rrr  r 
DD   DD oo  oo mmm  mm  mm KK KK  iii lll lll     333 rr     
DDDDDD   oooo  mmm  mm  mm KK  KK iii lll lll 333333  rr     

\e[0m\e[0;37mv: \e[30;38;5;120m2022.3\e[0m

\e[1;37m#Target must be : target.com ....[\e[30;38;5;197mno www / \e[30;38;5;197mno\e[1;37m http]
  \e[1;37m 
"""
}
curlcmd(){
  curlvar=$(curl -s -o /dev/null -w "%{http_code}" ${target}/${list} -L)
  if [[ $curlvar =~ "200" ]];
  then
    printf "[${i}] => ${target}/${list} => Found\n";
    echo "$target/$list" >> $doOutput/Found_dir.txt
  else
    printf "[${i}] => ${target}/${list} => Not Found\n";
    echo "$target/$list" >> $doOutput/Not_Found_dir.txt
  fi
}
####
header
read -p $'\e[30;38;5;130m[ + ]\e[30;38;5;217m Target \e[0m\e[1;37m:~ ' target
read -p $'\e[30;38;5;130m[ + ]\e[30;38;5;217m Number of threads from 1-100 :  \e[0m\e[1;37m:~ ' THREADS
doOutput="output/$target"
if [ ! -d "$doOutput" ]; then mkdir $doOutput ; fi
printf "\e[30;38;5;130m[ + ]\e[30;38;5;217m Dir: $doOutput \e[0m\e[1;37m\n"
for list in `cat dir.txt`;
do
 FAST=$(expr $i % $THREADS)
 if [[ $FAST == 0 && $i > 0 ]];
 then
   sleep 1
 fi
 curlcmd &
 i=$((i+1))
done
wait
