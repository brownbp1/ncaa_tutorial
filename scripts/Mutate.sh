#!/bin/bash

# Global variables
ROSETTA=/home/brownbp1/Rosetta/main/source/bin/rosetta_scripts.linuxgccrelease

# Input variables
XML=`readlink -e $1`
INPUT=`readlink -e $2`
PARAMS=`readlink -e $3`
POS=$4
RES=$5
PREFIX=$6

# Run
$ROSETTA \
-parser:protocol $XML \
-in:file:s "$INPUT" \
-in:path:database /home/brownbp1/Rosetta/main/database/ \
-parser:script_vars prefix="${PREFIX}" \
-parser:script_vars pos="${POS}" \
-parser:script_vars res="${RES}" \
-extra_res_fa ${PARAMS} \
-use_input_sc true \
-out:prefix $PREFIX \
-out:pdb_gz true \
-nstruct 1 \
-in:file:fullatom \
-ignore_zero_occupancy false \
-linmem_ig 10 \
-mute core.select.residue_selector.PrimarySequenceNeighborhoodSelector \
-overwrite > ${PREFIX}.log
