#!/bin/sh

SUPERVISE_MODULE_NAME=supervise.yecai-game-service
PRO_MODULE_NAME=yecai_game_server.rb

start() {
    stop

    SUPERVISE_CMD="ruby ./yecai_game_server.rb > /dev/null 2>&1 &"
    echo "SUPERVISE_CMD=$SUPERVISE_CMD"
}

stop() {
    killall ${SUPERVISE_MODULE_NAME}
    ps aux | grep $PRO_MODULE_NAME | grep -v grep | awk '{print $2}' | xargs kill -9
}

cmdName="control.sh"

case C"$1" in
    C)
    echo "Usage: $cmdName {start|stop}"
    ;;
    Cstart)
    start
    echo "done!"
    ;;
    Cstop)
    stop
    echo "done!"
    ;;
    Crestart)
    start
    echo "done!"
    ;;
    C*)
    echo "Usage: $cmdName {start|stop}"
    ;;
esac