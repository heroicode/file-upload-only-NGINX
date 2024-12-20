set dotenv-load
set ignore-comments

# default build action
@build:
    ./test.sh

# run tests (default)
@test: build

@configure:
    ./configure.sh

# remove certificates
@clean:
    docker compose down
    find upload -maxdepth 1 -exec sh -c 'echo deleting {}; rm {}' \;

# list commands we depend on
@depends:
    command -v docker
    command -v curl

[private]
@docker_all:
    docker compose create nginx
    docker compose up --detach
    docker compose exec nginx /bin/configure
    docker compose exec nginx sh -c '/bin/test-upload'
    docker compose down
