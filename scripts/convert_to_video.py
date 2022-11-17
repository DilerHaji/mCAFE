#!/usr/bin/env python
from sys import argv
from cv2 import VideoWriter, imread, VideoWriter_fourcc
from glob import glob
from os.path import getmtime
from tqdm import tqdm

glob_pattern = argv[1]
out_name = argv[2]

fourcc = VideoWriter_fourcc('M', 'J', 'P', 'G')
sorted_images = sorted(glob(glob_pattern), key=getmtime)
frame = imread(sorted_images[0])
height, width, layers = frame.shape

out = VideoWriter(out_name, fourcc, 1, (width, height), isColor=True)

for img in tqdm(sorted(glob(glob_pattern), key=getmtime), desc ="Making Video"):
    img = imread(img)
    #img = cv2.resize(img, (300, 167))
    out.write(img)

out.release()


# import cv2
# import os
# from glob import glob
# import sys
# from tqdm import tqdm
#
# glob_pattern = sys.argv[1]
# video_name = sys.argv[2]
#
# #glob_pattern = "111120222_microyalis/grabs/*jpg"
# #video_name = "111120222_microyalis.avi"
#
# sorted_images = sorted(glob(glob_pattern), key=os.path.getmtime)
#
# frame = cv2.imread(sorted_images[0])
# height, width, layers = frame.shape
#
# fourcc = cv2.VideoWriter_fourcc(*'DIVX')
# video = cv2.VideoWriter(video_name, fourcc, 1, (width,height))
#
# #for sorted_images in sorted_images:
# #    video.write(cv2.imread(sorted_images))
#
# for i in tqdm(range(len(sorted_images)), desc ="Making"):
#     filename = sorted_images[i]
#     img = cv2.imread(filename)
#     img = cv2.resize(img, (width,height))
#     video.write(img)
# video.release()
