#!/bin/sh

## headtail - do both a "head" and "tail" of stdin
## atom smasher
## v1.2a 27 dec 2022
## https://github.com/atom-smasher/headtail

## in theory, sh should be most portable, but this should run fine as a bash script, if needed

## requires 'pee' - https://joeyh.name/code/moreutils/
## quick sanity check, to see if "pv" is installed                                                                                
: | pee : : 2> /dev/null || {
	echo "error: ${0} requires 'pee', but pee was not found"
        echo 'See: https://joeyh.name/code/moreutils/'
        exit 99
}

show_help () {
    echo 'usage:'
    echo '  headtail [options] [LINES]'
    echo '  headtail [options]'
    echo '    -h           = help'
    echo '    -d DELIMITER = set a delimiter other than the default "--"'
    echo '    -D           = no DELIMITER'
    echo '    -n LINES     = how many lines of head and tail to output; default is 10'
    echo '    LINES        = how many lines of head and tail to ouput; default is 10'
    echo '    LINES may be specified as a single integer, or HEAD/TAIL; default is 10/10'
    echo '  headtail reads from stdin, and outputs LINES of head and LINES of tail'
    exit ${1}
}

## test if there's input on stdin
[ -t 0 ] && {
    show_help 100
}

## set this later; make it unset for now
unset lines

## set defaults here
delimiter=--

## options
while getopts "Dd:hn:" options
do
    case ${options} in
	d)
	    ## DELIMITER
	    ## set a DELIMITER other than the default '--'
	    delimiter="${OPTARG}"
	    ;;
	D)
	    ## no DELIMITER
	    unset delimiter
	    ;;
	h)
	    ## help
	    show_help 0
	    ;;
	n)
	    ## head/tail lines to show
	    lines_head="${OPTARG%%/*}"
	    lines_tail="${OPTARG##*/}"
	    ;;
	?)
	    ## error
	    show_help 102
	    ;;
    esac
done
shift $(( $OPTIND - 1 ))

## pre-process the LINES count from first argument, if needed
[ "$lines_head" ] || {
    lines_head="${1%%/*}"
}
[ "$lines_tail" ] || {
    lines_tail="${1##*/}"
}

## test if $lines is an integer
[ 0 -le ${lines_head:=10} -a 0 -le ${lines_tail:=10} ] 2> /dev/null || {
    show_help 101
}

## read from stdin, to both head and tail
pee  "head -n ${lines_head:=10} ; [ -z '${delimiter}' ] || echo '${delimiter}'" "tail -n ${lines_tail:=10}"
