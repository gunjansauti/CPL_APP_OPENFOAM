#!/bin/bash
#~~~
#    ________/\\\\\\\\\__/\\\\\\\\\\\\\____/\\\_____________
#     _____/\\\////////__\/\\\/////////\\\_\/\\\_____________
#      ___/\\\/___________\/\\\_______\/\\\_\/\\\_____________
#       __/\\\_____________\/\\\\\\\\\\\\\/__\/\\\_____________
#        _\/\\\_____________\/\\\/////////____\/\\\_____________
#         _\//\\\____________\/\\\_____________\/\\\_____________
#          __\///\\\__________\/\\\_____________\/\\\_____________
#           ____\////\\\\\\\\\_\/\\\_____________\/\\\\\\\\\\\\\\\_
#            _______\/////////__\///______________\///////////////__
#~~~
#

#Check if CPL path has been set by source SOURCEME.sh in CPL library
if [ -z $CPL_PATH ]; then
    echo "CPL PATH is not defined for cpl-library, "
    echo "trying to use CPL_INST_DIR file"
    CPL_SOURCEME=$(cat CPL_INST_DIR)/SOURCEME.sh

    if [ -f $CPL_SOURCEME ]; then
        source $CPL_SOURCEME
    else
        echo "WARNING:"
        echo " CPL library SOURCEME.sh file $CPL_SOURCEME not found."
    fi

fi


# Environment variable for install directory
export FOAM_CPL_VERSION=v2106
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd $DIR
export CWD=`pwd`

#Use CODE_INST_DIR file to define OpenFOAM to use
if [ -z $FOAM_INSTALL_DIR ]; then
    echo "FOAM_INSTALL_DIR is not defined, trying to use CODE_INST_DIR file"
    export FOAM_INSTALL_DIR=$(cat CODE_INST_DIR)
fi
# Source the other environment variables
foamDotFile=$FOAM_INSTALL_DIR/etc/bashrc
echo $foamDotFile
if [ -f $foamDotFile ]; then
    source $foamDotFile
else
    echo "ERROR:"
    echo "   Configuration file $foamDotFile not found."
    return 1
fi

echo ""
echo "FOAM_MPI environment variable is now: " $FOAM_MPI
export FOAM_MPI_LIBBIN=$FOAM_LIBBIN/$FOAM_MPI

# CPL APP environment variables
echo ""
echo "New environment variables: "
echo ""

export FOAM_CPL_APP=$CWD
echo "    FOAM_CPL_APP = " $FOAM_CPL_APP

export FOAM_CPL_APP_SRC=$FOAM_CPL_APP/src
echo "    FOAM_CPL_APP_SRC = " $FOAM_CPL_APP_SRC

export FOAM_CPL_APP_LIBBIN=$FOAM_CPL_APP/lib
echo "    FOAM_CPL_APP_LIBBIN = " $FOAM_CPL_APP_LIBBIN

export FOAM_CPL_APP_BIN=$FOAM_CPL_APP/bin
echo "    FOAM_CPL_APP_BIN = " $FOAM_CPL_APP_BIN

echo ""

# Update paths
export PATH=$PATH:$FOAM_CPL_APP_BIN
export LD_LIBRARY_PATH=$FOAM_CPL_APP_LIBBIN:$LD_LIBRARY_PATH
echo "PATH updated to:"
echo "   $PATH:"$FOAM_CPL_APP_BIN
echo
echo "LD_LIBRARY_PATH updated to: "
echo "  $FOAM_CPL_APP_LIBBIN:$LD_LIBRARY_PATH"
