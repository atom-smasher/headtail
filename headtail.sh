#!/bin/sh

## headtail - do both a "head" and "tail" of stdin
## atom smasher
## v1.1 26 dec 2022
## https://github.com/atom-smasher/headtail

## requires 'pee' - https://joeyh.name/code/moreutils/
## quick sanity check, to see if "pv" is installed                                                                                
: | pee : : 2> /dev/null || {
	echo "error: ${0} requires 'pee', but pee was not found in PATH"
        echo 'See: https://joeyh.name/code/moreutils/'
        exit 99
}

show_help () {
    echo 'usage:'
    echo '  headtail [-]LINES'
    echo '      headtail reads from stdin'
    echo '      headtail accepts LINES (an integer) as an option; default is 10'
    echo "      LINES may (or may not) be preceeded with a dash; it doesn't matter to me"
    echo '      headtail reads stdin, and outputs LINES of head and LINES of tail'
    exit ${1}
}

## test if there's input on stdin
[ -t 0 ] && {
    show_help 100
}

## pre-process the LINES count
lines=${1##-}
lines=${lines:=10}

## test if the first argument is an integer
## subsequent arguments are ignored
[ 0 -le ${lines} ] 2> /dev/null || {
    show_help 101
}

## read from stdin, to both head and tail
pee  "head -n ${lines} ; echo --"  "tail -n ${lines}"
