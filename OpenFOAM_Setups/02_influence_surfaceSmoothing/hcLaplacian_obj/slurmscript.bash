#!/bin/bash
#
#SBATCH --output=slurm.%j.out
#SBATCH --error=slurm.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=dominik.muetter@uni-wuppertal.de
#SBATCH --partition=local
#
#SBATCH --job-name=masterthesis_meshStudy_surfaceSmoothing_hcLaplacianSmoothing_obj
#SBATCH --time=0-20:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --mem=32G

source /usr/lib/openfoam/openfoam2506/etc/bashrc

# blockMesh
# 
# stitchMesh -perfect -overwrite OUT_FR IN_MAIN
# stitchMesh -perfect -overwrite OUT_MAIN IN_T
# 
# rm -rf 0
# 
# snappyHexMesh -overwrite
# 
# checkMesh -allGeometry -allTopology -allRegions -constant | tee checkMesh.log
# 
# renumberMesh -overwrite -constant -renumber-method reverseCuthillMcKee

decomposePar
# mpirun -np 32 potentialFoam -parallel -writePhi -writep -writephi -initialiseUBCs
mpirun -np 32 simpleFoam -parallel
reconstructPar -latestTime
