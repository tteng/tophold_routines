#!/bin/bash
cd /home/tiger
if [ "X$SSH_AUTH_SOCK" = "X" ]; then
    eval `ssh-agent -s`
    ssh-add /home/tiger/.ssh/id_rsa
fi

export AUTOSSH_POLL AUTOSSH_LOGFILE AUTOSSH_DEBUG AUTOSSH_PATH AUTOSSH_GATETIME AUTOSSH_PORT

autossh -p 22 -2 -fN -M 20000 -L 127.0.0.1:3228:localhost:3128 readline@bitdata.com
