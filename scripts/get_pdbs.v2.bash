#!/bin/bash
#############################
#
# Downloads PDB files from the Protein Data Bank
#
#############################

# Download link from PDB
URL=https://files.rcsb.org/download

# Download PDB files
tail -n+2 $1 | cut -c 1-4 | xargs -n1 -P4 -I% bash -c "curl -o %.pdb ${URL}/%.pdb"

# Compress files
gzip *.pdb

# Generate a list of PDB files 
readlink -e *.pdb.gz > pdb.list
