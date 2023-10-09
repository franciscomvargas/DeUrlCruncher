#!/bin/bash
# RUN WITHOUT SUDO
whoami=$(id -u)
if [ "$whoami" -eq 0  ];
then 
    echo "Please run without root"
    exit
fi


# Setup VARS
MODEL_NAME=DeUrlCruncher

# - Model Path
#   $PWD = \home\[username]\Desota\Desota_Models\DeUrlCruncher\executables\Linux
# PATH_TEST=~/Desota/Desota_Models/$MODEL_NAME/executables/Linux
MODEL_PATH=~/Desota/Desota_Models/$MODEL_NAME

SCRIPTPATH=$(realpath -s "$0")
BASENAME=$(basename $SCRIPTPATH)


# IPUT ARGS - -s="Start Model Service"; -d="Print stuff and Pause at end"
quiet=0
while getopts qe: flag
do
    case $flag in
        q) quiet=1;;
        ?) echo "Usage: %s: [-q]";;
    esac
done


# Copy File from future  deleted folder
if [ "$SCRIPTPATH" != "$HOME/$BASENAME" ];
then
    rm ~/$BASENAME
    cp $SCRIPTPATH ~/$BASENAME
    if [ "$quiet" -eq "0" ]; 
    then
        /bin/bash ~/$BASENAME
    else
        /bin/bash ~/$BASENAME -q
    fi
    exit
    # echo "Error:"
    # echo "# Description: Uninstall path dont correspond to expected:"
    # echo "    current_path = $SCRIPTPATH"
    # echo "    expected = $PATH_TEST/$BASENAME"
    # exit
else
    echo "Input Arguments:"
    echo "    quiet [-q]: $quiet"
fi

if [ "$quiet" -eq "0" ]; 
then
    rm -r $MODEL_PATH
else
    rm -rf $MODEL_PATH
fi

if ( test -d "$MODEL_PATH" ); then
    echo 'Uninstall Fail'
    echo "DEV TIP: Delete this folder:"
    echo "    $MODEL_PATH"
else
    echo 'Uninstalation Completed!'
fi

rm ~/$BASENAME
exit