#!/usr/bin/env bash

DEFAULT_HUGO_VERSION=0.55.6
if [ -z $HUGO_VERSION ]; then
    HUGO_VERSION=$DEFAULT_HUGO_VERSION
fi

DEFAULT_TEMP_DIR_PATH=/tmp/hugo
if [ -z $TEMP_DIR_PATH ]; then
    TEMP_DIR_PATH=$DEFAULT_TEMP_DIR_PATH
fi

TEMP_FILE_PATH=$TEMP_DIR_PATH/v$HUGO_VERSION.deb

BASE_PATH=https://github.com/gohugoio/hugo/releases/download
DOWNLOAD_URL=$BASE_PATH/v$HUGO_VERSION/hugo_${HUGO_VERSION}_Linux-64bit.deb

if [ -f $TEMP_FILE_PATH ]; then
    echo "Already exists hugo binaries..." 
else
    echo 'Install hugo binaries from github release...'

    mkdir -p $TEMP_DIR_PATH
    wget -O $TEMP_FILE_PATH $DOWNLOAD_URL
fi

dpkg -i $TEMP_FILE_PATH
