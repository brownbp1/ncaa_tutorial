#!/bin/bash
##########################
#
# Convenience wrapper for plotting benchmark rama diagrams.
# Note - Must be run from directory with data files in it.
#
#########################

# MakeRotLib 
python ../../scripts/plot_rama.py -input_file 5FW.qm_makerotlib_explicit_partial_chargesl_alpha_helix_0001_MH_Traj.dat -output_file 5FW.qm_makerotlib_explicit_partial_chargesl_alpha_helix_0001_MH_Traj.png -num_res 2 -x_label "Phi (degrees)" "Chi1 (degrees)" -y_label "Psi (degrees)" "Chi2 (degrees)" -input_file_native TRP.native_controll_alpha_helix_0001_MH_Traj.dat -font_size 14 &

# Parent rotamers
python ../../scripts/plot_rama.py -input_file 5FW.qm_parent_rotamers_explicit_partial_chargesl_alpha_helix_0001_MH_Traj.dat -output_file 5FW.qm_parent_rotamers_explicit_partial_chargesl_alpha_helix_0001_MH_Traj.png -num_res 2 -x_label "Phi (degrees)" "Chi1 (degrees)" -y_label "Psi (degrees)" "Chi2 (degrees)" -input_file_native TRP.native_controll_alpha_helix_0001_MH_Traj.dat -font_size 14 &

# PDB rotamers from BCL::Conf
python ../../scripts/plot_rama.py -input_file 5FW.qm_pdb_rotamers_explicit_partial_chargesl_alpha_helix_0001_MH_Traj.dat -output_file 5FW.qm_pdb_rotamers_explicit_partial_chargesl_alpha_helix_0001_MH_Traj.png -num_res 2 -x_label "Phi (degrees)" "Chi1 (degrees)" -y_label "Psi (degrees)" "Chi2 (degrees)" -input_file_native TRP.native_controll_alpha_helix_0001_MH_Traj.dat -font_size 14

