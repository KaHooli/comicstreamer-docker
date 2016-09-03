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
 
RUN apt-get update && apt-get install python python-pip python-dev git libjpeg-dev zlib1g-dev -y

#create the specified group
RUN addgroup abc --gid "${PGID}"

# Run commands as the comicstreamer user
RUN adduser \ 
	--disabled-login \ 
	--shell /bin/bash \ 
	--gecos "" \
        --uid "${PUID}" \
	--gid "${PGID}" \
        abc

# Copy & rights to folders
COPY run.sh /home/abc/run.sh

RUN chmod 777 /home/abc/run.sh

# create the comics directory
RUN mkdir "${DATA}" && chown "${PUID}:${PGID}" "${DATA}"

# create app and config directories

RUN mkdir -p "${APP}" && chown "${PUID}:${PGID}" "${APP}"

RUN mkdir -p "${CONFIG}" && chown "${PUID}:${PGID}" "${CONFIG}"

WORKDIR "${APP}"

#grab the latest version from git
RUN git clone https://github.com/Tristan79/ComicStreamer.git "${APPNAME}"

WORKDIR "${APP}/${APPNAME}"

RUN pip install `cat requirements.txt`

#make sure chosen user can run it
RUN chown -R "${PUID}:${PGID}" "${APP}/${APPNAME}"

USER abc 

RUN paver libunrar

# Expose default port : 32500
EXPOSE ${PORT}
# Expose User and group id 
EXPOSE ${PUID}
EXPOSE ${PGID}

VOLUME ${APP}
VOLUME ${CONFIG}
VOLUME ${DATA}

ENTRYPOINT ["/home/abc/run.sh"]
