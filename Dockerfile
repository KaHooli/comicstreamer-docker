FROM debian 

MAINTAINER ajw107

ENV PORT 32500
ENV WEBROOT ""
ENV PUID 999
ENV PGID 999
ENV CONFIG "/config"
ENV APP "/app"
ENV APPNAME "comicstreamer"
ENV DATA "/comics"

#make life easy for yourself
ENV TERM=xterm-color
#this only works on alpine images for some reason
#RUN echo $'#!/bin/bash\nls -alF --color=auto --group-directories-first --time-style=+"%H:%M %d/%m/%Y" --block-size="\'1" $@' > /usr/bin/ll
COPY root/ /
RUN chmod +x /usr/bin/ll

RUN apt-get update && apt-get install python python-pip python-dev git nano libjpeg-dev zlib1g-dev wget libavahi-compat-libdnssd1 -y
RUN mkdir -p /var/run/dbus

#create the specified group
#RUN addgroup abc --gid "${PGID}"

# Run commands as the comicstreamer user
#RUN adduser \ 
#	--disabled-login \ 
#	--shell /bin/bash \ 
#	--gecos "" \
#        --uid "${PUID}" \
#	--gid "${PGID}" \
#        abc

# Copy & rights to folders
COPY run.sh /home/abc/run.sh

RUN chmod 777 /home/abc/run.sh

# create the comics directory
#RUN mkdir "${DATA}" && chown "${PUID}:${PGID}" "${DATA}"

# create app and config directories

#RUN mkdir -p "${APP}" && chown "${PUID}:${PGID}" "${APP}"

#RUN mkdir -p "${CONFIG}" && chown "${PUID}:${PGID}" "${CONFIG}"

#WORKDIR "${APP}"

#grab the latest version from git
#RUN git clone https://github.com/Tristan79/ComicStreamer.git "${APPNAME}"

#WORKDIR "${APP}/${APPNAME}"

# Pybonjour must be installed manually
RUN pip install https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/pybonjour/pybonjour-1.1.1.tar.gz

#install the rest of the dependencies
RUN pip install argh backports.ssl-match-hostname certifi configobj natsort pathtools Pillow PyPDF2 python-dateutil PyYAML six SQLAlchemy tornado unrar watchdog paver pylzma

#make sure chosen user can run it
#RUN chown -R "${PUID}:${PGID}" "${APP}/${APPNAME}"

#USER abc 

#RUN paver libunrar

# cleanup
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
  /var/tmp/*

# Expose default port : 32500
EXPOSE ${PORT}
# Expose User and group id 
EXPOSE ${PUID}
EXPOSE ${PGID}

VOLUME ${APP}
VOLUME ${CONFIG}
VOLUME ${DATA}
VOLUME /var/run/dbus

ENTRYPOINT ["/home/abc/run.sh"]
