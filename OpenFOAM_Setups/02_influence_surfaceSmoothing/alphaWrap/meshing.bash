#!/bin/bash
#
#SBATCH --output=slurm.%j.out
#SBATCH --error=slurm.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=dominik.muetter@uni-wuppertal.de
#SBATCH --partition=local
#
#SBATCH --job-name=masterthesis_meshStudy_surfaceSmoothing_alphaWrap_meshing
#SBATCH --time=0-10:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --mem=20G

source /usr/lib/openfoam/openfoam2506/etc/bashrc

rm -rf 0
blockMesh
surfaceFeatureExtract
stitchMesh -perfect -overwrite OUT_FR IN_MAIN
stitchMesh -perfect -overwrite OUT_MAIN IN_T
rm -rf 0
decomposePar -force
mpirun -np 32 snappyHexMesh -parallel -overwrite
mpirun -np 32 checkMesh -allGeometry -allTopology -allRegions -constant -parallel | tee checkMesh.log
mpirun -np 32 checkMesh -constant -parallel | tee checkMesh_lessChecks.log
reconstructParMesh -constant
#checkMesh -allGeometry -allTopology -allRegions -constant | tee checkMesh.log
renumberMesh -overwrite -constant -renumber-method reverseCuthillMcKee
#rm -r processor*
