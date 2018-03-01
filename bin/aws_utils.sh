
info() {
	echo -e "[`date '+%m/%d/%Y-%H:%M:%S'`]::INFO::$1"
}


error() {
    echo -e "[`date '+%m/%d/%Y-%H:%M:%S'`]::ERROR::$1"
}

warn() {
    echo -e "[`date '+%m/%d/%Y-%H:%M:%S'`]::WARN::$1"
}


breaker_by_index() {
	info "----------------------------------------------------------|$1"
}

breaker() {
	info "----------------------------------------------------------"
}

resource_exists() {
	local cmd
	local matches
	if [[ -z "$2" ]]; then
		cmd="sudo $1 --query length(*[0])"
	else
		cmd="sudo $1 --query $2"
	fi
	if [[ "$?" -ne 0 ]]; then
		error "Could not check if resource exists, exiting."
		exit 2
	fi
	matches=$cmd
	if [[ "$matches" -gt 0 ]]; then
		return 0
	else
		return 1
	fi
}

resource_len() {
	local cmd
	local len
	cmd="sudo $1 --query length(*[]) --output json"
	if [[ "$?" -ne 0 ]]; then
		error "Could not check if resource exists, exiting."
		exit 2
	fi
	len=$($cmd)
	echo $len
}


resource_len_by_user() {
	local cmd
	local len
	cmd="sudo $1 --query length(*[]) --user-name $2 --output json"
	if [[ "$?" -ne 0 ]]; then
		error "Could not check if resource exists, exiting."
		exit 2
	fi
	len=$($cmd)
	echo $len
}


check_prog() {
	if [ ! -f "/tmp/$1.check" ]; then
		which $1
		if [ $? -ne 0 ]; then
			error "Could not find: $1, please install."
			exit 2
		fi
		touch /tmp/$1.check
		info "[$1] already installed, great!"
	fi
}


query() {
	jp -u "$2" <<<"$1"
}


if [ -z "$AWS_HELPER_HOME" ]; then
    error "AWS_HELPER_HOME must be set"
    exit 1
fi

breaker
check_prog "python"
check_prog "pip"
check_prog "jpterm"
check_prog "jp"
breaker
