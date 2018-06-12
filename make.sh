#!/bin/bash
set -e

dev_profile="nerd-cli-dev"

function print_help {
	printf "Available Commands:\n";
	awk -v sq="'" '/^function run_([a-zA-Z0-9-]*)\s*/ {print "-e " sq NR "p" sq " -e " sq NR-1 "p" sq }' make.sh \
		| while read line; do eval "sed -n $line make.sh"; done \
		| paste -d"|" - - \
		| sed -e 's/^/  /' -e 's/function run_//' -e 's/#//' -e 's/{/	/' \
		| awk -F '|' '{ print "  " $2 "\t" $1}' \
		| expand -t 30
}

function run_build { #build based on delft3d image
  docker build -t deltares/delft3d4:4.03.00-delwaq .
}

function run_run { #run the delwaq
  docker run -it deltares/delft3d4:4.03.00-delwaq /data/run_docker.sh $2
}

function run_flow {
  nerd login
  nerd dataset upload --name=flow-in ./flow-in
  nerd job run --input=flow-in:/data --output=flow-out:/data deltares/delft3d4
  nerd job list # check on jobs
  nerd logs #everything ok?
  nerd dataset upload --name=waq-in ./waq-in
  nerd job run --input=flow-out:/data-flowin --input=waq-in:/data-waqin --output=waq-out:/data-waqout quay.io/nerdalize/delft3d4-waq
  #check when ready
}

case $1 in
	"build") run_build ;;
  "run") run_run ;;
	*) print_help ;;
esac
