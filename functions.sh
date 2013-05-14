# name		: bash administration framework v04.2 
# subname	: because everyone is naming everything a framework now

# *see LICENSE.md for gplv3 information concerning this framework

# ABOUT:
# file		: functions.sh
# language	: US/English
# os support: SL6/RHEL6/CENTOS6/Arch#

# REQUIRED COMMAND MAPPINGS:
RM=$(which rm);			FIND=$(which find);
ECHO=$(which echo);		TPUT=$(which tput);
PS=$(which ps);			GREP=$(which grep);
MAIL=$(which mail);		SSH=$(which ssh);

# OPTIONAL COMMAND MAPPINGS:
# mainly for snippets
#local RSYNC=$(which rsync);	  local  TAR=$(which tar);
#local DC3DD=$(which dc3dd);	  local   DD=$(which dd);
#local 	 PV=$(which pv);	  local TIME=$(which time);
#local MYSQL=$(which mysql);	  local  YES=$(which yes);


# function debug() 			# echo debug information to screen and log if DEBUG is set to on
# 	usage: debug "the program broke"
#
function debug(){
	local msg="[debug] - $1"
	[ "$DEBUG" == "on" ] && $ECHO $msg
	[ "$DEBUG" == "on" ] && $ECHO $msg >> $LOGFILE
	return
 }

# function info() 			# post info to screen and log if INFO is set to on
# 	usage: info "text to output in case INFO is on"
#
function info(){
	local msg="[info] - $1"
	[ "$INFO" == "on" ] && $ECHO $msg
	[ "$INFO" == "on" ] && $ECHO $msg >> $LOGFILE
	return
}

# function cleanup() 		# run a cleanup before exiting
#	usage: cleanup
#
function cleanup(){
	debug "Starting cleanup..."
	$RM -f $TMPFILE
	debug "Finished cleanup"
	exit
}

# function failed() 		# error handling with trap
#	usage: none really
#
function failed() {
	local r=$?
	set +o errtrace
	set +o xtrace
	$ECHO "An error occurred..."
	cleanup
}

# function get_os_locs() 	# get os-specific tool locations into variables
#	usage: get_os_locs
#
function get_os_locs(){
	$ECHO
	# and so on...
}

# function change_ifs()		# change the default field seperator
# 	usage: change_ifs ":"
# NOTE: this is an environment-wide change! so be sure to undo it at the end
# of the script. I only include it because i use it often. Dont use this.
function change_ifs(){
	new_ifs=$1
	OLDIFS="${IFS}"
	IFS=$new_ifs
	return
}

# function revert_ifs()		# revert the default field seperator
# 	usage: revert_ifs ":"
# NOTE: this is an environment-wide change! so be sure to undo it at the end
# of the script. I only include it because i use it often. Dont use this.
function revert_ifs(){
	IFS=$OLDIFS
	return
}

# function check_regex()	# look for a regex in a string, if match return true
#	usage: if $(check_regex $some_var $some_regex_pattern) then; echo "true"
#
function check_regex(){
	local input=$1
	local regex=$2
	if [[ $input =~ $regex ]]; then
		# echo "found some regex"
		return true
	else
		# echo "did not find some regex"
		return false
	fi
}

# function usage()			# show the usage.dat file
#	usage: usage
#
function usage(){
	source usage.dat
}

# function mini_usage()		# show the mini_usage.dat file
#	usage: mini_usage
#
function mini_usage(){
	source mini_usage.dat
}

# function alert()			# alert sysadmin email/pager with an email
#	usage: alert "the program broke" "really bad" yes yes
#
function alert(){
	local error_subject=$1
	local error_message=$2
	local email=$3
	local pager=$4
	[ "$email" == "yes" ] && $MAIL -s '$error_subject' "$SYSADMIN_EMAIL" < "$error_message";
	[ "$pager" == "yes" ] && $MAIL -s '$error_subject' "$SYSADMIN_PAGER" < "$error_message";
}

# function only_run_as()	# only allow script to continue if uid matches
#	usage: only_run_as 0
#
function only_run_as(){
	if [[ $EUID -ne $1 ]]; then
		$ECHO "script must be run as uid $1" 1>&2
		exit
	fi
}

# function text()			# output text ERROR or OK with color (good for cli output)
#	usage: text error "there was some sort of error"
#	usage: text ok "everything was ok"
#
text() {
	local color=${1}
	shift
	local text="${@}"

	case ${color} in
		error  ) $ECHO -en "["; $TPUT setaf 1; $ECHO -en "ERROR"; $TPUT sgr0; $ECHO "] ${text}";;
		ok     ) $ECHO -en "["; $TPUT setaf 2; $ECHO -en "OK"; $TPUT sgr0; $ECHO "]    ${text}";;
	esac
	$TPUT sgr0
}

# function only_run_in()	# check that script is run from /root/bin
#	usage: only_run_in "/home/user"
#
only_run_in(){
	local cwd=`pwd`
	if [ $cwd != "$1" ]; then
		$ECHO "script must be run from $1 directory";
		exit
	fi
}

# function check_reqs()		# check that needed programs are installed
#	usage: none really (system)
#
function check_reqs(){
for x in "${REQUIRED_PROGS[@]}"
	do
		type "$x" >/dev/null 2>&1 || { $ECHO "$x is required and is NOT installed. Please install $x and try again. Exiting."; exit; }
	done
}

# function check_env()		# set tracing if dev or test environment
#	usage: none really (system)
#
function check_env(){
if [ $ENV != "prod" ] && [ $1 == "set" ]; then
	set -o errtrace 				# fail and exit on first error
	set -o xtrace					# show all output to console while writing script
fi
if [ $ENV != "prod" ] && [ $1 == "unset" ]; then
	set +o errtrace
	set +o xtrace
fi
}

function if_check_ip() {
	# check if ip is alive, if so then true and do this
	$ECHO
}

function wait_til_done(){
	# perhaps
	$ECHO
	wait
}

function paralell_exec() {
	# fire off multiple bg jobs
	$ECHO
}

function set_verbosity(){
	# Set verbosity for script output
	$ECHO
}

# never has so little been documented so well . . .
