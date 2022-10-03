#!/bin/bash

# Source environment
source /home/brownbp1/amber20/amber20/amber.sh

# Input variables
ESP=`readlink -e $1`
CHARGE=$2
PREFIX=$3
ATOM_TYPES=sybyl # This is the only antechamber atom type that molfile_to_params_polymer will parse

# Run
antechamber \
-fi gamess -i $ESP \
-fo mol2 -o $PREFIX.mol2 \
-rn $PREFIX -c resp -at $ATOM_TYPES -nc $CHARGE

antechamber \
-fi gamess -i $ESP \
-fo sdf -o $PREFIX.sdf \
-rn $PREFIX -c resp -at $ATOM_TYPES -nc $CHARGE
