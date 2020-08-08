#!/bin/bash

function generate_entry {
    echo ''
    echo "[program:ffmpeg-$1]"
    echo "command=/usr/src/profiles/${PROFILE:=passthrough}.sh '$1' '$2'"
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
    NAME=${ROW[0]}
    URL=${ROW[1]}

    if [[ ${NAME:0:1} == "#" ]]; then
        continue
    fi

    echo "[$i] name: ${NAME}"
    echo "[$i]  url: ${URL}"

    generate_entry "${NAME}" "${URL}"
done

cat /usr/src/supervisord.conf

#
# start supervisor
/usr/bin/supervisord -c /usr/src/supervisord.conf

