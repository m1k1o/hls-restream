#!/bin/bash

function generate_entry {
    echo ''
    echo "[program:ffmpeg-$1]"
    echo "command=/usr/src/ffmpeg.sh '$1' '$2'"
    echo 'autostart=true'
    echo 'autorestart=true'
    echo 'startretries=5'
    echo 'numprocs=1'
    echo 'startsecs=0'
    echo 'user=%(ENV_USER)s'
    echo 'process_name=%(program_name)s_%(process_num)02d'
    echo 'stderr_logfile=/var/log/supervisor/%(program_name)s_stderr.log'
    echo 'stderr_logfile_maxbytes=10MB'
    echo 'stdout_logfile=/var/log/supervisor/%(program_name)s_stdout.log'
    echo 'stdout_logfile_maxbytes=10MB'
} >> /usr/src/supervisord.conf

SAVEIFS=$IFS       # Save current IFS
IFS=$'\n'          # Change IFS to new line
SOURCES=($SOURCES) # split to array $SOURCES
IFS=$SAVEIFS       # Restore IFS

for (( i=0; i<${#SOURCES[@]}; i++ ))
do
    ROW=(${SOURCES[$i]})
    echo "[$i] name: ${ROW[0]}"
    echo "[$i]  url: ${ROW[1]}"

    generate_entry "${ROW[0]}" "${ROW[1]}"
done

cat /usr/src/supervisord.conf

#
# start supervisor
/usr/bin/supervisord -c /usr/src/supervisord.conf

