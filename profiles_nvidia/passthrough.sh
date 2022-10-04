#!/bin/sh
ffmpeg -hide_banner \
      -i "$2" \
      -map 0:v:0 -map 0:a:0 \
      -c:v copy \
      -c:a copy \
      -f hls \
            -hls_time 6 \
            -hls_list_size 4 \
            -hls_delete_threshold 1 \
            -hls_flags delete_segments \
            -hls_start_number_source datetime \
            "/var/www/html/$1.m3u8";

