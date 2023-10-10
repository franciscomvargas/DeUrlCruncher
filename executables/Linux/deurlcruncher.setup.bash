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
# - Model Release
MODEL_RELEASE=https://github.com/franciscomvargas/deurlcruncher/archive/refs/tags/v0.0.0.zip

# - Model Path
#   $PWD = \home\[username]\Desota\Desota_Models\DeUrlCruncher\executables\Linux
MODEL_PATH=~/Desota/Desota_Models/$MODEL_NAME

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
startmodel=0
debug=0
while getopts sde: flag
do
    case $flag in
        s) startmodel=1;;
        d) debug=1;;
        ?) echo $"Usage: %s: [-s] [-d]";;
    esac
done
echo "Input Arguments:"
echo "    startmodel [-s]: $startmodel"
echo "    debug [-d]: $debug"

# Move to Project Folder
if ( test -d "$MODEL_PATH" ); then
    cd $MODEL_PATH
    echo ''
    echo "Step 1/3 - Move (cd) to Project Path:"
    echo "    $PWD"
else
    echo "Error:"
    echo "# Description: Model not installed correctly"
    echo "    expected_path = $MODEL_PATH"
    echo ">DEV TIP< Download Release with this command:"
    echo "    rm -rf ~/Desota/Desota_Models/DeUrlCruncher && mkdir -p ~/Desota/Desota_Models/DeUrlCruncher && wget https://github.com/franciscomvargas/deurlcruncher/archive/refs/tags/v0.0.0.zip -O ~/DeUrlCruncher_release.zip && bsdtar -xzvf ~/DeUrlCruncher_release.zip -C ~/Desota/Desota_Models/DeUrlCruncher --strip-components=1 && rm -rf ~/DeUrlCruncher_release.zip"
    exit
fi

# Install Conda IF Required
echo ''
echo "Step 2/3 - Install Miniconda for Project"
# Install Conda if Required - https://developers.google.com/earth-engine/guides/python_install-conda#linux
# Miniconda Instalation Status
conda --version > /dev/null
condastatus=$?
if [ "$condastatus" -eq "0" ]; 
then
    echo "Miniconda Installed"
    
else
    echo "Miniconda Instalation Started..."
    # Download the Miniconda installer to your Home directory.
    echo "Miniconda Download URL:"
    echo "    $miniconda_dwnld"
    wget $miniconda_dwnld -O ~/miniconda.sh
    # Install Miniconda quietly, accepting defaults, to your Home directory.
    bash ~/miniconda.sh -b -u -p ~/Desota/Portables/miniconda3 > /dev/null
    # Remove the Miniconda installer from your Home directory.
    rm -rf ~/miniconda.sh
    # Add Miniconda to PATH variable
    printf '\n# added by DeSOTA installer\nexport PATH="$HOME/Desota/Portables/miniconda3/bin:$PATH"\n' >> ~/.bashrc
    chmod 666 ~/.bashrc
    eval_cmd=$(cat ~/.bashrc | tail -n +10)
    eval "$eval_cmd"

    conda --version
    # Dont start shell in (base)
    conda config --set auto_activate_base false
fi

# Create/Activate Conda Virtual Environment
echo "Creating MiniConda Environment..."
CONDA_BASE=$(conda info --base)
. $CONDA_BASE/etc/profile.d/conda.sh

if [ "$debug" -eq "1" ]; 
then
    conda create --prefix ./env -y
    conda activate ./env
else

    conda create --prefix ./env -y &> /dev/null
    conda activate ./env  &> /dev/null
fi

# Install required Libraries
echo ''
echo "Step 3/3 - Install Project Packages"
if [ "$debug" -eq "1" ]; 
then
    conda install pip -y
    pip install -r requirements.txt
else
    conda install pip -y &> /dev/null
    pip install -r requirements.txt &> /dev/null
    echo ''
    echo 'Packages Installed:'
    pip freeze
fi

echo ''
echo ''
echo 'Setup Completed!'
if [ "$startmodel" -eq "1" ]; 
then
    ~/Desota/Desota_Models/DeUrlCruncher/env/bin/python3 ~/Desota/Desota_Models/DeUrlCruncher/main.py
fi
exit
