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

t="linux"
a="amd64"
TARGET="${TARGET:-$t}"
ARCH="${ARCH:-$a}"



setup() {
    ls
    export DIR="$PWD"
    # mv cache/node_modules ./source
}

install_dependencies() {
    npm install
    print success "install dependencies"
}

lint() {
    install_dependencies
    npm run lint
    print success "lint passed"
}

test() {
    install_dependencies
    npm run test
    print success "tests passed"
}

build() {
    install_dependencies
	npm run build
    mv handler.js ${DIR}/executable
    print success "create a build"
}

    cd source/$directory
    print header "Current directory: $directory"

main() {
    if [ -z "$command" ]; then
        echo "Command is a required parameter and must be set."
        exit 1
    fi
    if [ -z "$directory" ]; then
        echo "No directory provided. Please set the parameter."
        exit 1
    fi

    setup

    case "$command" in
        'lint'        ) lint ;;
        'test'        ) test ;;
        'build'       ) build ;;
        *             ) echo "Command not supported: $command" && exit 1;;
    esac
}

main