docker-nginx-rtmp - A Dockerfile for VOD streaming via RTMP/HLS
===============================================================

Introduction
------------

The **docker-nginx-rtmp** is a Dockerfile to create a Docker image using Debian GNU/Linux 8 as base and install nginx-rtmp.

*Note: This is an experimental project to set up a nginx server for VOD streaming via RTMP/HLS.*

Build
-----

First, if you have not installed `debootstrap` and `docker.io`, execute the following command:

    $ sudo apt-get install debootstrap docker.io

Second, if you do not need to use `sudo` when you use the `docker` command, execute the following commands:

    $ sudo groupadd docker
    $ sudo gpasswd -a ${USER} docker

Third, set the values of variables in `make_docker_image` and `Dockerfile` to your needs, as shown in the following example:

    $ cat -n make_docker_image | awk 'NR>=8&&NR<=13'
         8  ARCH='i386'
         9  INCLUDE='iproute,locales'
        10  VARIANT='minbase'
        11  SUITE='jessie'
        12  TARGET="${SUITE}-${ARCH}"
        13  MIRROR='http://ftp.jp.debian.org/debian/'
    $ cat -n Dockerfile | awk 'NR<=6'
         1  FROM local/jessie-i386:minbase
         2  MAINTAINER KUSANAGI Mitsuhisa <mikkun@mbg.nifty.com>
         3
         4  ENV LANG ja_JP.utf8
         5  ENV NGINX_VERSION 1.8.0
         6  ENV RTMP_MODULE_VERSION 1.1.7

Fourth, execute `make_docker_image` to create a base image for Debian using `debootstrap`:

    $ ./make_docker_image

And finally, build your new image from `Dockerfile` (do not forget the dot at the end):

    $ docker build -t "local/jessie-<target architecture>:nginx-rtmp" .

Run
---

Start `nginx` using:

    $ docker run --name=nginx-rtmp -p 80:80 -p 1935:1935 -v /path/to/docker-nginx-rtmp/html:/usr/local/nginx/html -d -i -t local/jessie-<target architecture>:nginx-rtmp

If you see the demo page of RTMP/HLS streaming, visit `http://127.0.0.1/demo.html` with your browser.

Stop the currently running container:

    $ docker stop nginx-rtmp

Remove the stopped container:

    $ docker rm -v nginx-rtmp

ToDo
----

* MPEG-DASH support

References
----------

* Dockerfile:
    * Docker: <https://www.docker.com/>
    * Debootstrap: <https://wiki.debian.org/Debootstrap>
    * nginx: <http://nginx.org/>
    * nginx-rtmp-module: <https://github.com/arut/nginx-rtmp-module>
    * Libav: <https://libav.org/>
* Demo page:
    * X-15 Rocket Plane - First Free Flight: <https://archive.org/details/SF122>
    * rtmpPlayer: <https://github.com/mikkun/rtmpPlayer>
    * Video.js: <http://www.videojs.com/>
    * videojs-contrib-media-sources: <https://github.com/videojs/videojs-contrib-media-sources>
    * videojs-contrib-hls: <https://github.com/videojs/videojs-contrib-hls>

License
-------

Copyright 2015 KUSANAGI Mitsuhisa

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
