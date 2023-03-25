#!/bin/bash

# Copyright(c) 2023 Alex313031

YEL='\033[1;33m' # Yellow
CYA='\033[1;96m' # Cyan
RED='\033[1;31m' # Red
GRE='\033[1;32m' # Green
c0='\033[0m' # Reset Text
bold='\033[1m' # Bold Text
underline='\033[4m' # Underline Text

# Error handling
yell() { echo "$0: $*" >&2; }
die() { yell "$*"; exit 111; }
try() { "$@" || die "${RED}Failed $*"; }

# --help
displayHelp () {
	printf "\n" &&
	printf "${bold}${GRE}Script to build Atom-ng Flight Manual.${c0}\n" &&
	printf "${bold}${YEL}Use the --deps flag to install build dependencies.${c0}\n" &&
	printf "${bold}${YEL}Use the --bootstrap flag to install npm and ruby packages.${c0}\n" &&
	printf "${bold}${YEL}Use the --build flag to build site.${c0}\n" &&
	printf "${bold}${YEL}Use the --clean flag to run \`npm run distclean\`.${c0}\n" &&
	printf "${bold}${YEL}Use the --help flag to show this help.${c0}\n" &&
	printf "\n"
}
case $1 in
	--help) displayHelp; exit 0;;
esac

# Install prerequisites
installDeps () {
	sudo apt-get install build-essential git libsecret-1-dev libx11-dev libxkbfile-dev python2-dev ruby ruby-dev
}
case $1 in
	--deps) installDeps; exit 0;;
esac

cleanFlight () {
	printf "\n" &&
	printf "${bold}${YEL} Cleaning artifacts, node_modules, and output directory...${c0}\n" &&
	printf "\n" &&
	
	npm run distclean
}
case $1 in
	--clean) cleanFlight; exit 0;;
esac

buildFlight () {
# Optimization parameters
export CFLAGS="-DNDEBUG -O3 -g0 -s" &&
export CXXFLAGS="-DNDEBUG -O3 -g0 -s" &&
export CPPFLAGS="-DNDEBUG -O3 -g0 -s" &&
export LDFLAGS="-Wl,-O3 -s" &&
export NODE_ENV=production &&

printf "\n" &&
printf "${bold}${GRE} Building Flight Manual...${c0}\n" &&
printf "\n" &&

./script/bootstrap &&
NODE_ENV=development npm install &&
export NODE_ENV=production &&

./script/server
}
case $1 in
	--build) buildFlight; exit 0;;
esac

bootstrapFlight () {
# Optimization parameters
export CFLAGS="-DNDEBUG -O3 -g0 -s" &&
export CXXFLAGS="-DNDEBUG -O3 -g0 -s" &&
export CPPFLAGS="-DNDEBUG -O3 -g0 -s" &&
export LDFLAGS="-Wl,-O3 -s" &&
export NODE_ENV=production &&

printf "\n" &&
printf "${bold}${GRE} Bootstrapping...${c0}\n" &&
printf "\n" &&

./script/bootstrap &&
NODE_ENV=development npm install &&
export NODE_ENV=production
}
case $1 in
	--bootstrap) bootstrapFlight; exit 0;;
esac

printf "\n" &&
printf "${bold}${GRE}Script to build Atom-ng Flight Manual.${c0}\n" &&
printf "${bold}${YEL}Use the --deps flag to install build dependencies.${c0}\n" &&
printf "${bold}${YEL}Use the --bootstrap flag to install npm and ruby packages.${c0}\n" &&
printf "${bold}${YEL}Use the --build flag to build site.${c0}\n" &&
printf "${bold}${YEL}Use the --clean flag to run \`npm run distclean\`.${c0}\n" &&
printf "${bold}${YEL}Use the --help flag to show this help.${c0}\n" &&
printf "\n" &&

tput sgr0 &&
exit 0
