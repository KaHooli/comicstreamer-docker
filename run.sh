#!/usr/bin/env bash

cd "${APP}/${APPNAME}"

# Update repository
echo -e "Update comicstreamer..."
git pull 

OPTIONS="--nobrowser -p ${PORT} --user-dir ${CONFIG} ${DATA}"
# Run comicstreamer
if [ ${WEBROOT} ]; then 
	OPTIONS="$OPTIONS --webroot ${WEBROOT}"
fi

echo -e "Launch comicstreamer with options <$OPTIONS>"
./comicstreamer $OPTIONS
