#!/bin/bash

PRE=work/"$(basename $0)"-
IN=${PRE}.in
OUT=${PRE}.out

function init() {
    mkfifo $IN
    mkfifo $OUT
}

function background() {
    sed -e '/^QUIT$/q; s/^[ \t]*//; s/[ \t]*$//' <$IN >$OUT &
}

function output-to-thread() {
    local out
    cat - >$IN
    out="$(head -n 1 $OUT)"
    while [ -z "$out" ]; do
	out="$(head -n 1 $OUT)"
    done
    echo "$out"
}
    

function main() {
    init
    background
    echo "  rawr  " | output-to-thread
    echo "  meow  " | output-to-thread
    echo "  rawr  " | output-to-thread
    echo "QUIT" | output-to-thread
}

main "$@"