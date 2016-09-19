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
## Test sys_deps
### If any are missing, prompt for installation
### Install missing sys_deps


