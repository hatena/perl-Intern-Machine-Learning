#!/bin/sh

ROOT=$(cd $(dirname "$0")/..; pwd)

[ -z "$2" ] && {
    echo "Usage: $0 <max size> <command> [<args>...]"
    exit
}

i=0
MAX="$1"; shift

while true; do
    i=$((i + 1))
    "$ROOT/script/run" "$@" "$i" 2>/dev/null
    [ "$i" = "$MAX" ] && break
done
