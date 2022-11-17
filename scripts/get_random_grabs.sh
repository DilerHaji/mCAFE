#!/bin/bash

if [ -d "${1}/random_grabs" ];
then
  echo "${1}/random_grabs/ exist already! Delete then rerun this script."
else
  mkdir "${1}"/random_grabs

  ls "${1}"/grabs/*jpg | sort -R | head -$2 > "$1"/random_image_names.txt

  while read -r a;
  do
    cp "${a}" "${1}"/random_grabs &
  done < "${1}"/random_image_names.txt

fi
