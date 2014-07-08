#!/usr/bin/env bash

PROG=${0##*/}

# declare options and arguments
declare -a POSITIONAL_ARGS=()
declare OPT_s=0
declare OPT_l=0
declare OPT_o=0
declare OPT_h=0
declare OPT_VERSION=0
declare OPT_c=0
declare OPT_t=0
declare OPT_x=0
declare OPT_f=0
declare OPT_d=0
declare ARG_START_DATE
declare ARG_START_TIME
declare ARG_OUTPUT_FILE
declare -a ARG_TILL=()
declare ARG_CARD_NO
declare ARG_TID
declare ARG_TRNX_ID
declare ARG_SOURCE_DIR
declare ARG_TARGET_DIR
declare -a ARG_MULTIPLE_ARGS=()

function fnUsageNormal() {
	printf "%s  " "usage: ${PROG}" "-s|--start-datetime <start_date> [<start_time>]" "-l|--till <till> ..." "-o|--output-file <file> ""c|--card-no <card_no>" "[-t|--terminal-id <tid>]" "[-x|--trnx-id <trnx_id>]" "[-f|--file | -d|--dir]" "<source_dir>" "<target_dir>" "<multiple_args> ..." 1>&2
}

function fnUsageColored() {
	echo -e "usage: ${PROG} \e[2m-s|--start-datetime <start_date> [<start_time>] \e[0m-l|--till <till> ... \e[2m-o|-output-file <file> \e[0mc|--card-no <card_no> \e[2m[-t|--terminal-id <tid>] \e[0m[-x|--trnx-id <trnx_id>] \e[2m[-f|--file | -d|--dir] \e[0m<source_dir> \e[2m<target_dir> \e[0m<multiple_args> ...\e[0m" 1>&2
}

function fnUsageLined() {
	printf "\e[2musage:\t${PROG}\n" 1>&2
	printf "\e[2m\t%s\n\e[0m" "-s|--start-datetime <start_date> [<start_time>]" "-l|--till <till> ..." "-o|-output-file <file> ""c|--card-no <card_no>" "[-t|--terminal-id <tid>]" "[-x|--trnx-id <trnx_id>]" "[-f|--file | -d|--dir]" "<source_dir>" "<target_dir>" "<multiple_args> ..." 1>&2
}

function fnUsage() {
	#fnUsageNormal
	#fnUsageColored
	fnUsageLined
}

function fnPrintError() {
	printf "${PROG}: \e[31m$1\e[0m\n" 1>&2
}

function fnReadRequiredArg() {
	local -r arg="$1"
	local -r var_name="$2"
	local -r opt="$3"
	
	if [[ "$arg" == "" || ${arg:0:1} == "-" ]] ; then
		fnPrintError "option ${opt} requires an argument" ; fnUsage ; exit 1
	else
		eval "$var_name=$arg"
	fi
}

function fnReadOptionalArg() {
	local -r arg="$1"
	local -r var_name="$2"
	
	if [[ "$arg" != "" && ${arg:0:1} != "-" ]] ; then
		eval "$var_name=$arg"
	fi
}

function fnCheckRequiredOpt() {
	local -r opt_flag="$1"
	local -r opt_name="$2"
	
	if [[ $opt_flag == 0 ]] ; then
		fnPrintError "missing option ${opt_name}"
		fnUsage ; exit 1
	fi
}

function fnCheckRequiredPositionalArg() {
	local -r arg="$1"
	local -r arg_name="$2"
		
	if [[ -z "$arg" ]] ; then
		fnPrintError "missing argument ${arg_name}"
		fnUsage ; exit 1
	fi
}

# exit if no parameters are provided
if [[ -z "$1" ]] ; then
	fnUsage ; exit 1
fi

# extract options and arguments into variables
while [[ $# -gt 0 ]] ; do
    case "$1" in
        -s|--start-datetime)
					opt="$1"
					OPT_s=1
					shift
					
					fnReadRequiredArg "$1" ARG_START_DATE "${opt}" ; shift
					fnReadOptionalArg "$1" ARG_START_TIME ; [[ -z "${ARG_START_TIME}" ]] || shift
				;;
				-l|--till)
					opt="$1"
					OPT_l=1
					shift
					
					# just read for the sake of validation
					fnReadRequiredArg "$1" temp "${opt}"
					# read all args and shift
					ARG_TILL+="${temp}"
					while [[ "$1" != "" && ${1:0:1} != "-" ]] ; do
						ARG_TILL+=("$1") ; shift
					done
					
				;;
				-o|--output-file)
					opt="$1"
					OPT_o=1
					shift 2
				;;
				-c)
					opt="$1"
					OPT_c=1
					shift 2
				;;
        --) shift ; break ;;
				-*|--*)
					fnPrintError "illegal option $1" ; fnUsage ; exit 1
					shift
				;;
				*)
					POSITIONAL_ARGS+=("$1")
					shift
				;;
    esac
done

# check required options
fnCheckRequiredOpt $OPT_s "-s"
fnCheckRequiredOpt $OPT_l "-l"
fnCheckRequiredOpt $OPT_o "-o"
fnCheckRequiredOpt $(( $OPT_c || $OPT_t || $OPT_x )) "-c | -t | -x"


# extract positional arguments
# if the stdin given is a terminal [ -t 0 ]
# or there is more positional argument
if [[ -t 0 ]] || [[ $# -gt 0 ]]
then
	# read from terminal stdin
	for arg in "$@"
	do
		POSITIONAL_ARGS+=("$arg")
	done
else
	# read from file stdin
  while read -r line ; do
		POSITIONAL_ARGS+=("$line")
  done
fi

# assign positional arguments
ARG_SOURCE_DIR=${POSITIONAL_ARGS[0]}
ARG_TARGET_DIR=${POSITIONAL_ARGS[1]}
ARG_MULTIPLE_ARGS=("${POSITIONAL_ARGS[@]:2}")

# check required positional arguments
fnCheckRequiredPositionalArg "$ARG_SOURCE_DIR" "<source_dir>"
fnCheckRequiredPositionalArg "$ARG_TARGET_DIR" "<target_dir>"
fnCheckRequiredPositionalArg "$ARG_MULTIPLE_ARGS" "<multiple_args>"

# validate arguments
# TODO

echo "${POSITIONAL_ARGS[@]}"