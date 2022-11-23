#!/bin/bash
set -e
#
# install.sh
#
# Tristan M. Chase
#
# Installs loco.sh and any related scripts and system software needed to run it.  This script is built around apt as the package manager.

# Variables

## Dependencies

### System
sys_deps="findutils locate less wget vim" #findutils provides updatedb xargs

### loco-specific (my scripts)
script_deps="loco row filetype"

## Destination
dir=$HOME/bin

# Process

## Install missing $sys_deps
echo "Installing system software needed for loco to run..."
echo ""
sleep 2
sudo apt install $sys_deps
sleep 2
echo "Done installing system software."
echo ""

## Download raw $script_deps from GitHub to $dir
echo "Downloading script files from GitHub..."
echo ""
sleep 2

### Create destination directory and change to it
mkdir -p $dir
cd $dir

for file in $script_deps; do
	wget https://raw.githubusercontent.com/tristanchase/$file/main/$file.sh
	mv $file.sh $file # Rename the $file (drop the .sh)
	chmod 755 $file   # Make the $file executable
done

### Download how-to files
mkdir -p $dir/loco_help
cd $dir/loco_help
wget https://raw.githubusercontent.com/tristanchase/loco/main/how_to_use_loco.txt
wget https://raw.githubusercontent.com/tristanchase/loco/main/how_to_use_loco.html

## Create and populate the locate database
echo "Creating and populating the locate database. This will take a few minutes."
echo "Stand by..."
echo ""
sudo updatedb
echo ""
echo "locate database created."
echo ""

sleep 2
echo "Installation complete. You may now use loco by typing it on the command line."
echo ""

## Check to see if $dir is in $PATH

### If not, add it and modify .(bas|zs|oh-my-zs)hrc to include it.

## Make sure your locate database is up to date

exit 0
