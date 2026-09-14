#!/bin/bash
#
#SBATCH --output=slurm.%j.out
#SBATCH --error=slurm.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=dominik.muetter@uni-wuppertal.de
#SBATCH --partition=local
#
#SBATCH --job-name=masterthesis_meshingNeedles_comparison_smoothedSurface4
#SBATCH --time=0-12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=16G
#SBATCH --requeue

source /usr/lib/openfoam/openfoam2506/etc/bashrc

rm -rf 0
blockMesh
surfaceFeatureExtract
stitchMesh -perfect -overwrite OUT_FORERUNNING IN_MAIN
stitchMesh -perfect -overwrite OUT_MAIN IN_TAILING
rm -rf 0
decomposePar -force
mpirun -np 4 snappyHexMesh -overwrite -parallel
reconstructParMesh -constant
checkMesh -allGeometry -allTopology -allRegions -constant | tee checkMesh.log
renumberMesh -overwrite -constant -renumber-method reverseCuthillMcKee
