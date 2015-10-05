#! /bin/sh
PRO_NAME=chat_room_server.rb
ps aux | grep $PRO_NAME | grep -v grep | awk '{print $2}' | xargs kill -9
