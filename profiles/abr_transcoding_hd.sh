#!/bin/bash

function generate_playlist {
      echo '#EXTM3U'
      echo '#EXT-X-VERSION:3'
      echo '#EXT-X-STREAM-INF:BANDWIDTH=800000,RESOLUTION=640x360'
      echo "$1_360p.m3u8"
      echo '#EXT-X-STREAM-INF:BANDWIDTH=1400000,RESOLUTION=842x480'
      echo "$1_480p.m3u8"
      echo '#EXT-X-STREAM-INF:BANDWIDTH=2800000,RESOLUTION=1280x720'
      echo "$1_720p.m3u8"
} > "/var/www/html/$1.m3u8"
generate_playlist "$1"

ffmpeg -hide_banner \
      -i "$2" \
      -map 0:v:0 -map 0:a:0 \
      -vf scale=w=640:h=360:force_original_aspect_ratio=decrease \
            -c:a aac \
                  -ar 48000 \
                  -b:a 96k \
            -c:v h264 \
                  -profile:v main \
                  -b:v 800k \
                  -maxrate 856k \
                  -bufsize 1200k \
                  -crf 20 \
                  -sc_threshold 0 \
                  -g 48 \
                  -keyint_min 48 \
            -f hls \
                  -hls_time 6 \
                  -hls_list_size 4 \
                  -hls_delete_threshold 1 \
                  -hls_flags delete_segments \
                  -hls_start_number_source datetime \
                  -hls_segment_filename "/var/www/html/$1_360p_%03d.ts" \
                  "/var/www/html/$1_360p.m3u8" \
      -map 0:v:0 -map 0:a:0 \
      -vf scale=w=842:h=480:force_original_aspect_ratio=decrease \
            -c:a aac \
                  -ar 48000 \
                  -b:a 128k \
            -c:v h264 \
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
                  -hls_delete_threshold 1 \
                  -hls_flags delete_segments \
                  -hls_start_number_source datetime \
                  -hls_segment_filename "/var/www/html/$1_480p_%03d.ts" \
                  "/var/www/html/$1_480p.m3u8" \
      -map 0:v:0 -map 0:a:0 \
      -vf scale=w=1280:h=720:force_original_aspect_ratio=decrease \
            -c:a aac \
                  -ar 48000 \
                  -b:a 128k \
            -c:v h264 \
                  -profile:v main \
                  -b:v 2800k \
                  -maxrate 2996k \
                  -bufsize 4200k \
                  -crf 20 \
                  -sc_threshold 0 \
                  -g 48 \
                  -keyint_min 48 \
            -f hls \
                  -hls_time 6 \
                  -hls_list_size 4 \
                  -hls_delete_threshold 1 \
                  -hls_flags delete_segments \
                  -hls_start_number_source datetime \
                  -hls_segment_filename "/var/www/html/$1_720p_%03d.ts" \
                  "/var/www/html/$1_720p.m3u8";
