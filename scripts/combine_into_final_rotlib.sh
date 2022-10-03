#!/bin/bash

#################################
#
# Sample script to combine individual .rotlib files into
# a final rotamer library file for a params file
#
#################################

# Input variables
PREFIX=$1 # 3-letter code corresponding to the params PDB ID (e.g., TRP for tryptophan or 5FW in the example)
ROTLIB_DIR=`readlink -e $2` # Directory containing the individual .rotlib files
OUTPUT_FILE=$3
OMG=180
EPS=180

# Go to directory containing data
base_dir=$PWD
cd $ROTLIB_DIR

# Obtain the phi/psi ranges used to generate the library
for phi in `ls ${PREFIX}*.rotlib | awk -F_ '{print $3}' | grep [0-9] | sort -gk1 -u` ; do
	for psi in `ls ${PREFIX}*.rotlib | awk -F_ '{print $4}' | grep [0-9] | sort -gk1 -u`; do
		cat ${PREFIX}_${OMG}_${phi}_${psi}_${EPS}.rotlib
	done
done > ${base_dir}/$OUTPUT_FILE

# Return to starting directory
cd $base_dir
