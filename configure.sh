#!/usr/bin/env sh
set -o errexit -o nounset -o noclobber
dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)

cd "$dir"
conf=${conf:-./conf}
cd "$conf"

cd "$dir"
upload=${upload:-/var/spool/upload}
${in_docker:-false} && install -o nginx -g nginx -d "$upload"
cd "$upload"
