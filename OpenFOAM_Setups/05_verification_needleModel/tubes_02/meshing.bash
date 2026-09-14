#!/bin/bash
#
#SBATCH --output=slurm.%j.out
#SBATCH --error=slurm.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=dominik.muetter@uni-wuppertal.de
#SBATCH --partition=local
#
#SBATCH --job-name=masterthesis_modelVerification_meshing_tubes_02
#SBATCH --time=0-10:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --mem=50G

source /usr/lib/openfoam/openfoam2506/etc/bashrc

rm -rf 0

surfaceFeatureExtract

blockMesh
stitchMesh -perfect -overwrite OUT_FR IN_MAIN
stitchMesh -perfect -overwrite OUT_MAIN IN_T

rm -rf 0

decomposePar
mpirun -np 32 snappyHexMesh -overwrite -parallel
reconstructParMesh -constant

mpirun -np 32 checkMesh -parallel -allGeometry -allTopology -allRegions -constant | tee checkMesh.log
mpirun -np 32 checkMesh -parallel -constant | tee checkMesh_lessChecks.log

renumberMesh -overwrite -constant -renumber-method reverseCuthillMcKee
