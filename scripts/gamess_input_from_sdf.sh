#!/bin/bash
############################################################################################################################
#
# Convenience script to generate input file for GAMESS from two files:
# (1) An input SDF
# (2) A header file containing the desired GAMESS settings (electron correlation treatment, basis set, etc.)
#
############################################################################################################################

# Input variables
SDF=`readlink -e $1` # Input molecule(s)
HEADER=`readlink -e $2` # Header options for GAMESS input
CHARGE=$3
MULTIPLICITY=$4

# Derived varibales
tag=`basename $SDF .sdf`

# Generate coordinates for GAMESS from SDF
obabel -i sdf $SDF -o gamin -O ${tag}.gamin

# Add the header to the coordinate file
grep -A1000000 -B1 "\$DATA" ${tag}.gamin | cat $HEADER - > ${tag}.inp
rm -f ${tag}.gamin

# Set charge and multiplicity
sed -i "s:ICHARG=:ICHARG=${CHARGE}:" ${tag}.inp
sed -i "s:MULT=:MULT=${MULTIPLICITY}:" ${tag}.inp
