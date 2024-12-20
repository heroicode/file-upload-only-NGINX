#!/usr/bin/env sh
# shellcheck disable=SC2039  # local keyword is fine, actually
set -o errexit -o nounset -o noclobber
dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd); cd "$dir"
conf=${conf:-./conf}
in_docker=${in_docker:-false}

[ -e ./.env ] && . ./.env

NGINX_HTTP=${NGINX_HTTP:-80}
base_url=http://localhost:"$NGINX_HTTP"/upload

$in_docker || docker compose up --detach

curl() { command curl --fail-with-body -sS "$@"; }
check() {
    # echo "-$result-"
    [ "$content" = "$result" ] || {
        echo "expected"
        echo "-$content-"
        echo "actual"
        echo "...$result..."
        false; }
}
content="$(printf "123\n\n\n." | sed /[.]/d)"
printf "%s" "$content" \
    | curl -X PUT "$base_url"/123.txt --data @- -H 'content-type: text/plain'
result=$(curl "$base_url"/123.txt)
check

content=$(seq 10 42)
result=$(printf "%s" "$content" \
    | curl -X PUT "$base_url"/123.txt --data @- -H 'content-type: text/plain' \
        2>/dev/null \
    || true )
content='{"message":"Request Entity Too Large"}'
check

$in_docker || docker compose down
