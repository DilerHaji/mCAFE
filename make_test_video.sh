#!/bin/bash

cd $1
wget -O convert_to_video.py https://raw.githubusercontent.com/DilerHaji/mCAFE/master/scripts/convert_to_video.py
wget -O get_random_grabs.sh https://raw.githubusercontent.com/DilerHaji/mCAFE/master/scripts/get_random_grabs.sh

array=($(ls -d */ | tr -d /))
echo ${array[@]}

for box in "${array[@]}"
do
  ./get_random_grabs.sh "${box}" 3
done

for box in "${array[@]}"
do
  python convert_to_video.py "${box}/random_grabs/*jpg" "${box}_test.avi"
done
