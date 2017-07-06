#!/bin/bash

find ./ -name '*.sh' | awk -F "/" '{print $3}'| while read i
do
    echo "$i%.*"
    # svn rename ${i%.*}.sh  ${i%.*}.bash
done
