#!/bin/bash

#
# Check that a file "runid" exists ...
#
if [ ! -f /data-waqin/runid ]; then
    echo Error: no run-ID file given > delwaq.log
    exit
fi

#
# Set the directory containing delwaq executables here
#
export ARCH=lnx64
export D3D_HOME=/opt/delft3d_4.03.00
exedir=$D3D_HOME/$ARCH/waq/bin

#
# No adaptions needed below
#

# Set some (environment) parameters
export LD_LIBRARY_PATH=$exedir:$LD_LIBRARY_PATH

# Run DELWAQ1

cp -r /data-waqin/* .
echo y >> runid

$exedir/delwaq1 -p $exedir/../default/proc_def <runid 1>delwaq.log 2>&1
rc=$?

# Run DELWAQ2 if possible

if [ $rc -eq 0 ]; then
    $exedir/delwaq2 <runid 1>>delwaq.log 2>&1
else
    echo !                                        >>delwaq.log
    echo ! Error running DELWAQ1 - please check!  >>delwaq.log
    echo !                                        >>delwaq.log
fi

cp * /data-waqout
