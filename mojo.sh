#!/usr/bin/env bash

##===--------------------------------===##
## This file is Modular Inc proprietary. ##
##===--------------------------------===##

##===--------------------------------===##
##  SOURCE: https://get.modular.com/    ##
##  Deobfuscated and cleaned up by      ##
##  @pythoninthegrass                   ##
##===--------------------------------===##

set -euo pipefail

usage() {
	echo "usage: MODULAR_AUTH= $0"; exit 2
}

GIT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# get the root directory
if [ -n "$GIT_ROOT" ]; then
	TLD="$(git rev-parse --show-toplevel)"
else
	TLD="${SCRIPT_DIR}"
fi

ENV_FILE="${TLD}/.env"

# source .env file skipping commented lines
if [[ -f "${ENV_FILE}" ]]; then
	export $(grep -v '^#' ${ENV_FILE} | xargs)
elif [[ -n $(env | grep MODULAR_AUTH) ]]; then
	echo "Found MODULAR_AUTH in env vars"
fi

# check for required variables, then fallback to arguments
if [ -z "${MODULAR_AUTH:-}" ]; then
	echo "error: no MODULAR_AUTH provided."
	usage
elif [ -z "${MODULAR_AUTH:-}" ] && [ "$#" -ne "0" ]; then
	echo "error: invalid arguments."
	usage
fi

maybe_sudo() {
	if [ "$(whoami)" = "root" ]; then
		"$@"
	elif type sudo > /dev/null; then
		sudo -E "$@"
	else
		echo "Sorry, either root or 'sudo' is required."; return 1
	fi
}

remote_script() {
	# Prefer curl over wget, but wget is available by default. We shouldn't need
	# any fallback path where packages are installed. Note that for older shells
	# we do not have pipefail available, therefore ensure that on failure we pipe
	# in a failure that will result in failure of the function.
	if type curl > /dev/null; then
		(curl -1sLf "$1" || echo "exit 1") | maybe_sudo bash
	elif type wget > /dev/null; then
		(wget -q -O - "$1" || echo "exit 1") | maybe_sudo bash
	else
		echo "Sorry, one of 'curl' or 'wget' is required."
		return 1
	fi
}

# Reliably detecting whether a system is Deb-based or RPM-based can be tricky,
# as both tools can be installed on a system. Complex cases may need to fall
# back to manual setup, however it should be the case Debian-deriviatives have
# /etc/debian_version, while this file should not be present in
# non-Debian-based systems.

if [ "$(uname)" = "Linux" ] && [ -f "/etc/debian_version" ]; then
	remote_script "https://dl.modular.com/${URL_SLUG:-"public/installer"}/setup.deb.sh"
	maybe_sudo apt install -yq --reinstall modular
elif [ "$(uname)" = "Linux" ] && type rpm > /dev/null && type dnf > /dev/null; then
	remote_script "https://dl.modular.com/${URL_SLUG:-"public/installer"}/setup.rpm.sh"
	maybe_sudo dnf -yq install modular || \
	(maybe_sudo dnf -q list installed modular &>/dev/null \
	&& maybe_sudo dnf -yq reinstall modular)
elif [ "$(uname)" = "Linux" ] && type rpm > /dev/null && type yum > /dev/null; then
	remote_script "https://dl.modular.com/${URL_SLUG:-"public/installer"}/setup.rpm.sh"
	maybe_sudo yum -yq install modular || \
	(maybe_sudo yum -q list installed modular &>/dev/null \
	&& maybe_sudo yum -yq reinstall modular)
else
	echo "Sorry, this system is not recognized. Please visit https://www.modular.com/mojo to learn about supported platforms. You can also build and run a Mojo container by following instructions at https://github.com/modularml/mojo."; exit 1
fi

modular auth "$MODULAR_AUTH"

# TODO: fix ascii art ;_;
cat << EOF
Welcome to the Modular CLI!
For info about this tool, type "modular --help".
To install Mojo 🔥, type "modular install mojo".
For Mojo documentation, see https://docs.modular.com/mojo.
To chat on Discord, visit https://discord.gg/modular.
To report issues, go to https://github.com/modularml/mojo/issues.
EOF

exit 0
