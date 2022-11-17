#!/bin/bash

if [ -d $1/random_grabs ];
then

  rm $1/random_grabs/*

  ls $1/grabs/*jpg | sort -R | head -$2 > $1/random_image_names.txt

  while read -r a;
  do
    cp -p "${a}" $1/random_grabs &
  done < $1/random_image_names.txt

else

  mkdir $1/random_grabs

  ls $1/grabs/*jpg | sort -R | head -$2 > $1/random_image_names.txt

  while read -r a;
  do
    cp -p "${a}" $1/random_grabs &
  done < $1/random_image_names.txt

fi
