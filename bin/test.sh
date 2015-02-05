#!/bin/bash


t=$@
for i in $t
do
    echo $i
done

PWDir=$(dirname $(cd $(dirname $0) ; pwd))
echo $PWDir
