# Comicstreamer - Docker

Docker build for Comicstreamer ([Tristan79 version](https://github.com/Tristan79/ComicStreamer))
Retrieve the last version on github and launch comicstreamer.

## Usage

`docker run -d -p 32500:32500 -e PUID=<User ID> -e PGID=<Group ID> -v /config/directory:/config -v /my/comics/directory:/comics kahooli/comicstreamer`

## Variables
+ __WEBROOT__
Webroot for comicstreamer (default : none)
+ __PORT__
Port of comicstreamer (default : 32500)
+ __PUID__
User to run as (default : 999)
+ __PGID__
Group to run as (default : 999)
+ __CUSTOMOPTIONS__
Another customs options for launching comicstreamer.

## Volumes
+ __/config__
Configuration files directory
+ __/comics__
Comics directory
+ __/var/run/dbus__
Path to dbus socket for avahi

## Expose
+ Port : 32500 : comicstreamer default port

## Known issues
