#!/bin/bash

cd $1

array=($(ls -d */ | tr -d /))
echo ${array[@]}

for box in "${array[@]}"
do
  print "$box"/grabs
  print "$box".avi
  python ../convert_to_video.py "${box}/grabs/*jpg" "${box}.avi" &
done
