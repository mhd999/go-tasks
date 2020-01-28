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
    export DIR="$PWD"
}

install_dependencies() {
    if [ -d node_modules ]; then
        echo "dependencies exists"
    else
        npm install
        print success "install dependencies"
    fi
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
    mv $build/* ${DIR}/executable/
    ls ${DIR}/executable/  # debug
    print success "create a build"
}

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

    cd source/$directory
    print header "Current directory: $directory"

    case "$command" in
        'lint'        ) lint ;;
        'test'        ) test ;;
        'build'       ) build ;;
        *             ) echo "Command not supported: $command" && exit 1;;
    esac
}

main