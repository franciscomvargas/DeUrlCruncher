#!/bin/bash

# GET USER PATH
get_user=$(who)
USER=${get_user%% *}
USER_HOME="/home/$USER"



# -- Edit bellow vvvv DeSOTA DEVELOPER EXAMPLe: miniconda + pip pckgs + python cli script

# Setup VARS
MODEL_NAME=DeUrlCruncher
# - Model Path
MODEL_PATH=$USER_HOME/Desota/Desota_Models/$MODEL_NAME
# - Conda Environment
MODEL_ENV=$MODEL_PATH/env
CONDA_PATH=$USER_HOME/Desota/Portables/miniconda3/bin/conda



# -- Edit bellow if you're felling lucky ;) -- https://youtu.be/5NV6Rdv1a3I

# IPUT ARGS: -q="Quiet uninstall"; -p="User Password"
quiet=0
while getopts qhe: flag
do
    case $flag in
        q)  quiet=1;;
        h)  { 
            echo "Usage:"; 
            echo "sudo $0 [-q] [-h]";
            echo "    -q = Hands Free (quiet)";
            echo "    -h = Help";
            echo "    [] = Optional";
            exit 1;
        };;
        ?)  { 
            echo "Usage:"; 
            echo "sudo $0 [-q] [-h]";
            echo "    -q = Hands Free (quiet)";
            echo "    -h = Help";
            echo "    [] = Optional";
            exit 1;
        };;
    esac
done

# Copy File from future  deleted folder
SCRIPTPATH=$(realpath -s "$0")
BASENAME=$(basename $SCRIPTPATH)
if test "$SCRIPTPATH" = "$USER_HOME/$BASENAME"
then
    echo "Input Arguments:"
    echo "    quiet [-q]: $quiet"
else

    # SUPER USER RIGHTS
    [ "$UID" -eq 0 ] || { 
        echo "Please consider running this script with root, miniconda can require it!"; 
        echo "Usage:"; 
        echo "sudo $0 [-q] [-h]";
        while true; do
            echo
            read -p " # Continue as user? [y|n]: " iknowhatamidoing
            case $iknowhatamidoing in
                [Yy]* ) break;;
                [Nn]* ) exit 1;;
                * ) echo "    Please answer yes or no.";;
            esac
        done
    }

    if ( test -e "$USER_HOME/$BASENAME" ); then
        rm -rf $USER_HOME/$BASENAME
    fi
    cp $SCRIPTPATH $USER_HOME/$BASENAME
    #chown -R $USER $USER_HOME/$BASENAME
    if [ "$quiet" -eq "0" ]; 
    then
        /bin/bash $USER_HOME/$BASENAME
    else
        /bin/bash $USER_HOME/$BASENAME -q
    fi
    exit
fi

if [ "$quiet" -eq "0" ]; 
then
    # DELETE PCKGS
    $CONDA_PATH remove --prefix $MODEL_ENV --all --force
    
    # DELETE PROJECT
    echo
    echo "Deleting permanently Project..."
    echo "    Project path: $MODEL_PATH"
    rm -r $MODEL_PATH
else
    # DELETE PCKGS
    echo
    echo "The packages from the following environment will be REMOVED:"
    echo "    Package Plan: $MODEL_ENV"
    $CONDA_PATH remove --prefix $MODEL_ENV --all --force -y&> /dev/null

    # DELETE PROJECT
    echo
    echo "Deleting recursively Project..."
    echo "    Project path: $MODEL_PATH"
    rm -rf $MODEL_PATH
fi

if ( test -d "$MODEL_PATH" ); then
    echo 'Uninstall Fail'
    echo ">DEV TIP< Delete this folder:"
    echo "    $MODEL_PATH"
else
    echo 'Uninstalation Completed!'
fi

rm -rf $USER_HOME/$BASENAME
exit
