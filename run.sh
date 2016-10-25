#!/usr/bin/env bash

chown -R "${PUID}:${PGID}" /home/abc

#we need to restart dbus to pick up the linked volume before avahi will start
service dbus restart
service avahi-daemon start

if [ -z "$(getent group abc)" ]
then
    #the group doesn;t exist, so create it
    addgroup abc --gid "${PGID}"
elif [ ! "$(id -g abc)" -eq "${PGID}" ]
then
    #the group exists, but we need to change their id
    groupmod -o -g "${PGID}" abc
fi

if [ -z "$(getent passwd abc)" ]
then
    # the user does not exist, create it
    adduser \
        --disabled-login \
        --shell /bin/bash \
        --gecos "" \
        --uid "${PUID}" \
        --gid "${PGID}" \
        abc
elif [ ! "$(id -u abc)" -eq "${PUID}" ]
then
    #the user does exist,but we need to change their id
    usermod -o -u "$PUID" abc
fi

if [ ! -d "${DATA}" ]
then
    # create the comics directory
    mkdir "${DATA}"
fi
#chown -R "${PUID}:${PGID}" "${DATA}"

# create app and config directories
if [ ! -d "${APP}" ]
then
    mkdir -p "${APP}"
fi

#make sure we have the right permissions
chown -R "${PUID}:${PGID}" "${APP}"

#now set up the config directory, unless it already exists
if [ ! -d "${CONFIG}" ]
then
    mkdir -p "${CONFIG}"
fi
chown -R "${PUID}:${PGID}" "${CONFIG}"

#got to set this here, as can't set any variables after the su command for some reason
CS_OPTIONS="--nobrowser -p ${PORT} --user-dir ${CONFIG} ${DATA}"
# Run comicstreamer
if [ ! -z "${WEBROOT}" ]
then
    CS_OPTIONS="${CS_OPTIONS} --webroot ${WEBROOT}"
fi

su abc <<EOF

cd "${APP}"

if [ ! -d "${APP}/${APPNAME}/.git" ]
then
    #grab the latest version from git
    git clone https://github.com/Tristan79/ComicStreamer.git "${APPNAME}"
    cd "${APP}/${APPNAME}"
    paver libunrar
else
    cd "${APP}/${APPNAME}"
    git stash
    git pull
fi

echo "APP: [${APP}]"
echo "APPNAME: [${APPNAME}]"
echo "PORT: [${PORT}]"
echo "CONFIG: [${CONFIG}]"
echo "DATA: [${DATA}]"
echo "CS_OPTIONS: [${CS_OPTIONS}]"

#phew, now we get to run it eventually
./comicstreamer $CS_OPTIONS
EOF

