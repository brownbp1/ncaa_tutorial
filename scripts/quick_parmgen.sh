#!/bin/bash

###############################
#
# Quick shell script to generate Rosetta params for NCAAs using rotamers from BCL::Conf
# Adapted from molfile_to_params_polymer_main.py scripts by Oanh Vu and Rocco Moretti
# BCL application GenerateRosettaNCAAInstructions written by Benjamin P. Brown
#
###############################

# Executables
PYTHON=/usr/bin/python2.7
BCL=/home/brownbp1/bensbin/ncaa_tutorial_rdg/from_github/bcl/build/linux64_release/bin/bcl-apps-static.exe
ROSETTA=/home/brownbp1/Rosetta/main/source/scripts/python/public/molfile_to_params_polymer.py

# Input variables
sdf=`readlink -e $1`
codename=$2
#gly=`readlink -e $3`
gly=/home/brownbp1/bensbin/ncaa_tutorial_rdg/from_github/bcl/rotamer_library/ncaa_base/glycine_neutral.sdf.gz
w_dir=`readlink -e $3`

# Derived variables
tag=`basename ${sdf} .sdf`

# go to working directory
cd $w_dir

# generate initial 3D conformer
$BCL molecule:ConformerGenerator \
	-explicit_aromaticity \
	-add_h \
	-generate_3D \
	-max_iterations 2000 \
	-top_models 1 \
	-ensemble_filenames $sdf \
	-conformers_single_file ${tag}_3d.sdf

# generate rosetta instructions
$BCL molecule:GenerateRosettaNCAAInstructions \
	-generate_3D \
	-chirality "L_AA" \
	-add_h \
	-neutralize \
	-explicit_aromaticity \
	-input_filenames ${tag}_3d.sdf \
	-output_prefix ${tag}_rosetta \
	-extra_properties ALPHA_AA

# generate conformers
$BCL molecule:ConformerGenerator \
	-explicit_aromaticity \
	-conformation_comparer SymmetryRMSD 0.25 \
	-max_iterations 2000 \
	-top_models 50 \
	-cluster \
	-ensemble_filenames ${tag}_rosetta_0.sdf \
	-conformers_single_file ${codename}_Rotamer.base.sdf

$BCL molecule:ConformerGenerator \
	-explicit_aromaticity \
	-conformation_comparer SymmetryRMSD 0.125 \
	-max_iterations 500 \
	-top_models 20 \
	-cluster \
	-skip_rotamer_dihedral_sampling \
	-skip_bond_angle_sampling \
	-skip_ring_sampling \
	-ensemble_filenames ${codename}_Rotamer.base.sdf \
	-conformers_single_file ${codename}_Rotamer.sdf


# align to backbone (cosmetic)
$BCL molecule:AlignToScaffold $gly ${codename}_Rotamer.sdf ${codename}_Rotamer.ats.sdf -explicit_aromaticity ; mv ${codename}_Rotamer.ats.sdf ${codename}_Rotamer.sdf 

# Add the cap atoms instruction to the rotamer file
sed -e "/M  END/r ${tag}_rosetta.RosettaInstructions.txt" ${codename}_Rotamer.sdf | awk '!f && /M  END/ {f=1;next}1' > ${codename}_Rotamer_rosetta.sdf

# Make the pdb files for the molecules and the rostamer lib
rm -f ${codename}_params.log
$PYTHON $ROSETTA --clobber --polymer --all-in-one-pdb --name ${codename} -i ${codename}_Rotamer_rosetta.sdf >> ${codename}_params.log

# Add PDB rotamers with full path
echo "PDB_ROTAMERS" `readlink -e ${codename}_rotamer.pdb` >> ${codename}.params
