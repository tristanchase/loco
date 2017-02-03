#!/bin/bash
#
# loco_install.sh
#
# Tristan M. Chase
#
# Installs loco.sh and any related scripts and system software neede to run it.


# Variables

## Dependencies

### System
sys_deps="findutils less" #locate updatedb xargs

### loco-specific
script_deps="loco row filetype"

## Destination
dir=$HOME/bin

# Process

## Install missing $sys_deps
echo "Installing system software needed for loco to run..."
echo ""
sleep 2
sudo aptitude install $sys_deps
sleep 2
echo "Done installing system software."
echo ""

## Download raw $script_deps from GitHub to $dir
echo "Downloading script files from GitHub..."
echo ""
sleep 2

# Create destination directory and change to it
mkdir -p $dir
cd $dir

for file in $script_deps; do
	wget https://raw.githubusercontent.com/tristanchase/$file/master/$file.sh 
	mv $file.sh $file # Rename the $file (drop the .sh) 
	chmod 755 $file   # Make the $file executable
done

sleep 2
echo "Installation complete. You may now use loco by typing it on the command line."
echo ""

## Check to see if $dir is in $PATH

### If not, add it and modify .(bas|zs|oh-my-zs)hrc to include it.

## Make sure your locate database is up to date


