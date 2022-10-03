#!/bin/bash

#################################
#
# CPPTRAJ wrapper for phi, psi, chi1, and chi2 dihedral angle calculation
#
#################################

# Input variables
PARM=`readlink -e $1`
TRAJ=`readlink -e $2`
RES=$3
OUTPUT=$4

# Write
cat > cpptraj.compute_dihedrals.in << EOF
parm $PARM
trajin $TRAJ
multidihedral resrange $RES phi psi dihtype chi1:N:CA:CB:CG dihtype chi2:CA:CB:CG:CD1 out $OUTPUT
run
quit
EOF
cpptraj.OMP -i cpptraj.compute_dihedrals.in
rm -f cpptraj.compute_dihedrals.in
