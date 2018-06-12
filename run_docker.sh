#!/bin/bash

#
# Set the config file here
#
# argfile=config_d_hydro.xml

#
# Set the directory containing delftflow.exe here
#
export ARCH=lnx64
export D3D_HOME=/opt/delft3d_4.03.00
exedir=$D3D_HOME/$ARCH/waq/bin

#
# No adaptions needed below
#

# Set some (environment) parameters
export LD_LIBRARY_PATH=$exedir:$LD_LIBRARY_PATH

# Run 1
ls -l /opt
$exedir/delwaq1 /data-waqin/params.inp
ls .

$exedir/delwaq2 /data-waqin/params.inp
ls .

cp params.* /data-waqout
