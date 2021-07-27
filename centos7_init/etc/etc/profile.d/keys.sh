tempfile=$(mktemp)
authorized_keys=$HOME/.ssh/authorized_keys

USER_PPID=$PPID
if [ `id -u` != 0 ];then
    USER_PPID=`ps --no-header o ppid -p$PPID | xargs`
fi

lg_rsa=$( sudo cat /var/log/secure | awk -vp=$USER_PPID '
    (/Accepted publickey/ || /Found matching RSA key/) && $0~p { print $NF;exit }' )

NAME_OF_KEY=unknown
if [ -f "$authorized_keys" ]; then
    while read line ;do
        keyfromName=$(echo "$line" | tee $tempfile | awk '{print $3}')
        cr_rsa=$(ssh-keygen -l -f $tempfile | awk '{print $2}')
        [ -z "$lg_rsa" -o -z "$cr_rsa" ] && continue
        [ "$lg_rsa" != "$cr_rsa" ] && continue
        NAME_OF_KEY=$keyfromName
        rm -f $tempfile
        break
    done < $authorized_keys
fi

readonly NAME_OF_KEY
export NAME_OF_KEY
if [ -n "$BASH_EXECUTION_STRING" ]; then
    logger -t -bash[$USER_PPID] "HISTORY: SSH_CLIENT=\"$SSH_CLIENT\" User=$USER SSH_USER=$NAME_OF_KEY CMD=$BASH_EXECUTION_STRING" &>/dev/null
fi
