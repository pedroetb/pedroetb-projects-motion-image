ARG ALPINE_IMAGE_TAG=3.11.3

FROM alpine:${ALPINE_IMAGE_TAG}

LABEL maintainer="pedroetb@gmail.com"

ARG MOTION_VERSION=release-4.3.0

ARG AUTOCONF_VERSION=2.69-r2
ARG AUTOMAKE_VERSION=1.16.1-r0
ARG BUILD_BASE_VERSION=0.5-r1
ARG PKGCONF_VERSION=1.6.3-r0
ARG LIBTOOL_VERSION=2.4.6-r7
ARG LIBZIP_DEV_VERSION=1.5.2-r0
ARG LIBJPEG_TURBO_DEV_VERSION=2.0.4-r0
ARG FFMPEG_DEV_VERSION=4.2.1-r3
ARG LIBWEBP_DEV_VERSION=1.0.3-r0
ARG GETTEXT_DEV_VERSION=0.20.1-r2
ARG GIT_VERSION=2.24.1-r0
ARG LIBMICROHTTPD_DEV_VERSION=0.9.69-r0
RUN apk --no-cache add --virtual=build-deps \
		autoconf=${AUTOCONF_VERSION} \
		automake=${AUTOMAKE_VERSION} \
		build-base=${BUILD_BASE_VERSION} \
		pkgconf=${PKGCONF_VERSION} \
		libtool=${LIBTOOL_VERSION} \
		libzip-dev=${LIBZIP_DEV_VERSION} \
		libjpeg-turbo-dev=${LIBJPEG_TURBO_DEV_VERSION} \
		ffmpeg-dev=${FFMPEG_DEV_VERSION} \
		libwebp-dev=${LIBWEBP_DEV_VERSION} \
		gettext-dev=${GETTEXT_DEV_VERSION} \
		git=${GIT_VERSION} && \
	apk --no-cache add \
		libmicrohttpd-dev=${LIBMICROHTTPD_DEV_VERSION} && \
	git config --global advice.detachedHead false && \
	git clone --branch ${MOTION_VERSION} --depth 1 https://github.com/Motion-Project/motion.git && \
	cd motion ; \
	autoreconf -fiv && \
	./configure && \
	make clean && \
	make && \
	make install && \
	cd .. ; \
	rm -rf motion ; \
	apk del build-deps

ARG TZDATA_VERSION=2019c-r0
ARG CA_CERTIFICATES_VERSION=20191127-r1
ARG IMAGEMAGICK_VERSION=7.0.9.7-r0
ARG FFMPEG_VERSION=4.2.1-r3
ARG X264_VERSION=20191119-r0
ARG WGET_VERSION=1.20.3-r0
RUN apk --no-cache add \
	tzdata=${TZDATA_VERSION} \
	ca-certificates=${CA_CERTIFICATES_VERSION} \
	imagemagick=${IMAGEMAGICK_VERSION} \
	ffmpeg=${FFMPEG_VERSION} \
	x264=${X264_VERSION} \
	wget=${WGET_VERSION}

VOLUME /usr/local/etc/motion
VOLUME /var/lib/motion

CMD ["motion", "-n"]
