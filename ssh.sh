#!/bin/sh

## Check Arguments

if [ -z "$1" ] ; then
    echo "Usage: scriptname hostname"
    exit 1
fi

## Parameters

USERNAME="user"
PASSWORD="password"
HOST="$1"
PORT="22"
SSHDIR=".ssh"
SERVERHOME="/home/nayan"
AUTHORIZED_KEYS="authorized_keys"
KEYFILE="id_rsa.pub"

## Passwordless SSH

if [ -e "${HOME}/${SSHDIR}/${KEYFILE}" ] ; then
    echo "Public Key Already Exists. Skipping SSH RSA Key Generation."
else
    ssh-keygen -t rsa # Generate Key
fi

ssh "${USERNAME}"@"${HOST}" -p "${PORT}" << EOF

if [ -e "${SERVERHOME}/${SSHDIR}" ] ; then
  echo "Directory Exists"
else
  echo "Creating Directory -> ${SERVERHOME}/${SSHDIR}"
  mkdir "${SERVERHOME}/${SSHDIR}"
fi

if [ -e "${SERVERHOME}/${SSHDIR}/${AUTHORIZED_KEYS}" ] ; then
  echo "File Exists"
else
  echo "Creating File -> ${SERVERHOME}/${SSHDIR}/${AUTHORIZED_KEYS}"
  touch "${SERVERHOME}/${SSHDIR}/${AUTHORIZED_KEYS}"
fi

chmod 700 "${SERVERHOME}/${SSHDIR}"
chmod 640 "${SERVERHOME}/${SSHDIR}/${AUTHORIZED_KEYS}"

EOF

ssh-copy-id -i "${HOME}/${SSHDIR}/${KEYFILE}" "$USERNAME"@"$HOST" -p "$PORT"

#cat "${HOME}/${SSHDIR}/${KEYFILE}" | ssh "$USERNAME"@"$HOST" -p "$PORT" "cat >> ${SERVERHOME}/${SSHDIR}/${AUTHORIZED_KEYS}"
