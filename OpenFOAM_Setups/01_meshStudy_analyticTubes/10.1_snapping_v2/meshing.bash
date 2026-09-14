#!/bin/bash
#
#SBATCH --output=slurm.%j.out
#SBATCH --error=slurm.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=dominik.muetter@uni-wuppertal.de
#SBATCH --partition=local
#
#SBATCH --job-name=masterthesis_meshStudy_10_meshing
#SBATCH --time=5-11:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=64
#SBATCH --mem=150G


source /usr/lib/openfoam/openfoam2506/etc/bashrc

rm -rf 0

blockMesh

stitchMesh -perfect -overwrite OUT_FR IN_MAIN
stitchMesh -perfect -overwrite OUT_MAIN IN_T

rm -rf 0

decomposePar

mpirun -np 64 --oversubscribe snappyHexMesh -overwrite -parallel

reconstructParMesh -constant

mpirun -np 64 --oversubscribe checkMesh -allGeometry -allTopology -allRegions -constant -parallel | tee checkMesh.log
mpirun -np 64 --oversubscribe checkMesh -parallel -constant | tee checkMesh_lessChecks.log

renumberMesh -overwrite -constant -renumber-method reverseCuthillMcKee
