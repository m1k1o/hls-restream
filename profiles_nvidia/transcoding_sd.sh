#!/bin/bash

cd "$(dirname "$0")"
source .helpers.sh

ffmpeg -hide_banner -hwaccel cuvid -c:v "$(cuvid_codec "$2")" \
      -i "$2" \
      -sn \
      -vf yadif_cuda=0:-1:0,scale_npp=842:480 \
            -c:a aac \
                  -ar 48000 \
                  -b:a 128k \
            -c:v h264_nvenc \
                  -profile:v main \
                  -b:v 1400k \
                  -maxrate 1498k \
                  -bufsize 2100k \
                  -crf 20 \
                  -sc_threshold 0 \
                  -g 48 \
                  -keyint_min 48 \
            -f hls \
                  -hls_time 6 \
                  -hls_list_size 4 \
                  -hls_wrap 10 \
                  -hls_delete_threshold 1 \
                  -hls_flags delete_segments \
                  -hls_start_number_source datetime \
                  -hls_segment_filename "/var/www/html/$1_%03d.ts" \
                  "/var/www/html/$1.m3u8";
