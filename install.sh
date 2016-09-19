#!/bin/bash

# Install loco and its dependencies to $HOME/bin.

# Variables

## Dependencies

### System
sys_deps="locate updatedb xargs"

### loco-specific
files="loco row filetype"

## Destination
dir=$HOME/bin

# Process

## Test $sys_deps

### If any are missing, prompt for installation

### Install missing $sys_deps

## Download raw $files from GitHub to $dir

## Rename the $files (drop the .sh)

## Make the $files executable

## Check to see if $dir is in $PATH

### If not, add it and modify .(bas|zs|oh-my-zs)hrc to include it.

## Make sure your locate database is up to date


