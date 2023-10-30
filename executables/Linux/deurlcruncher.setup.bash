#!/bin/bash

# GET USER PATH
get_user=$(who)
USER=${get_user%% *}
USER_HOME="/home/$USER"


# -- Edit bellow vvvv DeSOTA DEVELOPER EXAMPLe (Python - Tool): miniconda + pip pckgs + python cli script

# SETUP VARS
MODEL_NAME=DeUrlCruncher
# - Model Release
MODEL_RELEASE=https://github.com/franciscomvargas/deurlcruncher/archive/refs/tags/v0.0.0.zip
# - Model Path
#   $PWD = \home\[username]\Desota\Desota_Models\DeUrlCruncher\executables\Linux
MODEL_PATH=$USER_HOME/Desota/Desota_Models/$MODEL_NAME
# Conda Instalation
MODEL_ENV=$MODEL_PATH/env
PIP_REQS=$MODEL_PATH/requirements.txt
PYTHON_MAIN="$MODEL_PATH/main.py  --noclear"



# -- Edit bellow if you're felling lucky ;) -- https://youtu.be/5NV6Rdv1a3I

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

# >>Libraries required<<
echo "Step 0/4 - Check Required apt instalations"
echo "    libarchive-tools"
apt install libarchive-tools -y &>/dev/nul

# Program Installers
#   - Miniconda
architecture=$(uname -m)
case $architecture in
        x86_64) miniconda_dwnld=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh;;
        x86) miniconda_dwnld=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86.sh;;
        aarch64) miniconda_dwnld=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh;;
        arm) miniconda_dwnld=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-armv7l.sh;;
        s390x) miniconda_dwnld=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-s390x.sh;;
        ppc64le) miniconda_dwnld=https://repo.aanaconda.com/miniconda/Miniconda3-latest-Linux-ppc64le.sh;;
        ?) miniconda_dwnld=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh;;
esac
# IPUT ARGS - -s="Start Model Service"; -d="Print stuff and Pause at end"
manualstart=0
debug=0
while getopts mdhe: flag
do
    case $flag in
        m) manualstart=1;;
        d) debug=1;;
        h) { 
            echo "Usage:"; 
            echo "sudo $0 [-m] [-d] [-h]";
            echo "    -m = Start Service Manually";
            echo "    -d = Echo everything (debug)";
            echo "    -h = Help";
            echo "    [] = Optional";
            exit 1;
        };;
        ?) {
            echo "Usage:"; 
            echo "sudo $0 [-m] [-d] [-h]";
            echo "    -m = Start Service Manually";
            echo "    -d = Echo everything (debug)";
            echo "    -h = Help";
            echo "    [] = Optional";
            exit 1;
        };;
    esac
done
echo "Input Arguments:"
echo "    manualstart [-m]: $manualstart"
echo "    debug [-d]: $debug"

# Move to Project Folder
if ( test -d "$MODEL_PATH" ); 
then
    cd $MODEL_PATH
    echo
    echo "Step 1/3 - Move (cd) to Project Path:"
    echo "    $PWD"
else
    echo "Error:"
    echo "# Description: Model not installed correctly"
    echo "    expected_path = $MODEL_PATH"    
    echo "DEV TIP:"
    echo "# Download Release with this command:"
    echo "    rm -rf ~/Desota/Desota_Models/DeUrlCruncher && mkdir -p ~/Desota/Desota_Models/DeUrlCruncher && wget https://github.com/franciscomvargas/deurlcruncher/archive/refs/tags/v0.0.0.zip -O ~/DeUrlCruncher_release.zip && bsdtar -xzvf ~/DeUrlCruncher_release.zip -C ~/Desota/Desota_Models/DeUrlCruncher --strip-components=1 && rm -rf ~/DeUrlCruncher_release.zip"
    exit
fi

# Install Conda IF Required
echo
echo "Step 2/3 - Install Miniconda for Project"
# Install Conda if Required - https://developers.google.com/earth-engine/guides/python_install-conda#linux
# Miniconda Instalation Status
CONDA_BASE=$USER_HOME/Desota/Portables/miniconda3
. $CONDA_BASE/etc/profile.d/conda.sh
conda --version > /dev/null
condastatus=$?
if [ "$condastatus" -eq "0" ];
then
    echo "    Miniconda Installed"
else
    echo "    Miniconda Instalation Started..."
    # Download the Miniconda installer to your Home directory.
    echo "Miniconda Download URL:"
    echo "    $miniconda_dwnld"
    wget $miniconda_dwnld -O $USER_HOME/miniconda.sh
    chown -R $USER $USER_HOME/miniconda.sh
    # Install Miniconda quietly, accepting defaults, to your Home directory.
    bash $USER_HOME/miniconda.sh -b -u -p $USER_HOME/Desota/Portables/miniconda3 > /dev/null
    chown -R $USER $USER_HOME/Desota/Portables
        # Remove the Miniconda installer from your Home directory.
    rm -rf $USER_HOME/miniconda.sh
    # Add Miniconda to PATH variable
    chmod 666 $USER_HOME/.bashrc
    _tmp_conda_PATH=$USER_HOME/Desota/Portables/miniconda3/bin/conda
    
    $_tmp_conda_PATH init bash
    runuser -l $USER -c "$_tmp_conda_PATH init bash" 
    
    eval_cmd=$(cat ~/.bashrc | tail -n +16)
    eval "$eval_cmd"

    # Dont start shell in (base)
    conda config --set auto_activate_base false
fi


# Create/Activate Conda Virtual Environment
echo "Creating MiniConda Environment..."
if [ "$debug" -eq "1" ]; 
then
    conda create --prefix $MODEL_ENV -y
    conda activate $MODEL_ENV
else
    conda create --prefix $MODEL_ENV -y&> /dev/null
    conda activate $MODEL_ENV&> /dev/null
fi
echo "    $CONDA_PREFIX"


# Install required Libraries
echo
echo "Step 3/3 - Install Project Packages"
export TMPDIR='/var/tmp'
if [ "$debug" -eq "1" ]; 
then
    conda install pip -y
    pip install -r $PIP_REQS --compile --no-cache-dir 2>/dev/null
fi
if [ "$debug" -ne "1" ]; 
then
    conda install pip -y &> /dev/null
    pip install -r $PIP_REQS --compile --no-cache-dir &> /dev/null
    echo
    echo 'Packages Installed:'
    pip freeze
fi
# Delete pip tmp files
rm -rf /var/tmp/pip-*&> /dev/null
# Deactivate CONDA
conda deactivate
chown -R $USER $MODEL_ENV

echo
echo
echo 'Setup Completed!'
# Start Model ?
if [ "$manualstart" -eq "0" ]; 
then
    $MODEL_ENV/bin/python3 $PYTHON_MAIN
fi
exit
