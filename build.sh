#!/bin/sh
DIR=$(dirname $(readlink -f $0))
DIR_OUTPUT="${DIR}/output"
rm -rf $DIR_OUTPUT
mkdir $DIR_OUTPUT
cp -r $DIR/server/src/* $DIR_OUTPUT
cp -r $DIR/control/* $DIR_OUTPUT
