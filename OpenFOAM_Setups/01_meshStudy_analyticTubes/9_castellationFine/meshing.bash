#!/bin/bash
#
#SBATCH --output=slurm.%j.out
#SBATCH --error=slurm.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=dominik.muetter@uni-wuppertal.de
#SBATCH --partition=local
#
#SBATCH --job-name=masterthesis_meshStudy_9_meshing
#SBATCH --time=0-10:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=20G

source /usr/lib/openfoam/openfoam2506/etc/bashrc

blockMesh

stitchMesh -perfect -overwrite OUT_FR IN_MAIN
stitchMesh -perfect -overwrite OUT_MAIN IN_T

rm -rf 0

snappyHexMesh -overwrite

checkMesh -allGeometry -allTopology -allRegions -constant | tee checkMesh.log

renumberMesh -overwrite -constant -renumber-method reverseCuthillMcKee