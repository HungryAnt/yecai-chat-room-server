#!/bin/sh

PRO_HOME=$(dirname $(readlink -f $0))
PRO_NAME=yecai-game-service

SUPERVISE_MODULE_NAME=supervise.$PRO_NAME
SUPERVISE_MODULE="${PRO_HOME}/${SUPERVISE_MODULE_NAME}"

PRO_MODULE_NAME=yecai_game_server.rb
PRO_MODULE="${PRO_HOME}/${PRO_MODULE_NAME}"

start() {
    stop

    STATUS_DIR="${PRO_HOME}/status"
    [ -d $STATUS_DIR ] || mkdir $STATUS_DIR

    chmod +x $SUPERVISE_MODULE

    SUPERVISE_CMD="ruby ${PRO_MODULE}"
    echo "SUPERVISE_CMD=$SUPERVISE_CMD"
    $SUPERVISE_MODULE -p ${STATUS_DIR}/${PRO_NAME} -f "$SUPERVISE_CMD" >/dev/null 2>&1 &
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