#!/bin/sh

set -e

print() {
    local GREEN='\033[1;32m'
    local YELLOW='\033[1;33m'
    local RED='\033[0;31m'
    local NC='\033[0m'
    local BOLD='\e[1m'
    local REGULAR='\e[0m'
    case "$1" in
        'failure' ) echo -e "${RED}✗ $2${NC}" ;;
        'success' ) echo -e "${GREEN}√ $2${NC}" ;;
        'warning' ) echo -e "${YELLOW}⚠ $2${NC}" ;;
        'header'  ) echo -e "${BOLD}$2${REGULAR}" ;;
    esac
}


TARGET ?= linux
ARCH ?= amd64


setup() {
    export DIR="$PWD"
    curl -L -s https://github.com/golang/dep/releases/download/v0.4.1/dep-linux-amd64 -o $GOPATH/bin/dep
    chmod +x $GOPATH/bin/dep
    print success "install dep"
}

dep_insure() {
    dep ensure -v
    print success "install dependencies"
}

test() {
    dep_insure
    go test ./... --cover
    print success "tests passed"
}

build() {
    dep_insure
	env GOOS=$(TARGET) GOARCH=$(ARCH) go build -ldflags="-s -w" -o bin/"$entrypoint" "$entrypointPath"
    print success "create a build"
    zip bin/"$entrypoint".zip bin/"$entrypoint" > executable
    print success "zip build executable"
}

main() {
    if [ -z "$command" ]; then
        echo "Command is a required parameter and must be set."
        exit 1
    fi
    if [ -z "$directories" ]; then
        echo "No directories provided. Please set the parameter."
        exit 1
    fi

    setup
    for directory in $directories; do
        if [ ! -d "$DIR/source/$directory" ]; then
            print failure "Directory not found: $directory"
            exit 1
        fi
        cd $DIR/source/$directory
        print header "Current directory: $directory"

        case "$command" in
            'test'        ) test ;;
            'build'       ) build ;;
            *             ) echo "Command not supported: $command" && exit 1;;
        esac
    done
}

main