#!/bin/bash

if [ -d "random_grabs/" ];
then
  echo "random_grabs/ exist already! Delete then rerun this script."
else
  mkdir random_grabs

  ls grabs/*jpg | sort -R | head -$1 > random_image_names.txt

  while read -r a;
  do
    cp "${a}" random_grabs &
  done < random_image_names.txt

fi
