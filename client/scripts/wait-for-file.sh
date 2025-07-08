#!/bin/sh

if [ $# -lt 3 ] ; then
  echo "Usage: wait-for-file.sh FILENAME WAIT_TIME CMD [ARGS…]" >&2
  exit 1
fi

configFile="$1"; shift
waitTime="${1:-90}"; shift
timer=$waitTime

cmd="$1"; shift
cmdArgs="$@"

while [ ! -f "$configFile" ] ; do
  if [ "$timer" -le 0 ] ; then
    echo "Error: File '$configFile' not found after $waitTime seconds" >&2
    exit 1
  fi
  echo "Waiting for file: $configFile ($timer s left)"
  sleep 1
  timer=$((timer - 1))
done

echo "File $configFile found. Executing: $cmd $cmdArgs"
exec "$cmd" $cmdArgs
