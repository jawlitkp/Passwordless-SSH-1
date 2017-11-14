#!/bin/sh

## Check Arguments

if [ $# -ne 2 ] ; then
    echo "Usage: scriptname hostname stricthostcheck"
	echo "Example: ./ssh.sh 10.10.10.10 no"
    exit 1
fi

## Parameters

USERNAME="username"
PASSWORD="password"
HOST="$1"
STRICTHOSTCHECK="$2"
PORT="22"
SSHDIR=".ssh"
SERVERHOME="/home/nayan"
AUTHORIZED_KEYS="authorized_keys"
KEYFILE="id_rsa.pub"

# Remove Faulty Keys

ssh-keygen -R "${HOST}"

## Passwordless SSH

if [ -e "${HOME}/${SSHDIR}/${KEYFILE}" ] ; then
	echo "Public Key Already Exists. Skipping SSH RSA Key Generation."
else
	ssh-keygen -q -t rsa # Generate Key
fi

ssh -o StrictHostKeyChecking="${STRICTHOSTCHECK}" "${USERNAME}"@"${HOST}" -p "${PORT}" << EOF

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
