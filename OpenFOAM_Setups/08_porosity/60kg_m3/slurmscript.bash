#!/bin/bash
#
#SBATCH --output=slurm.%j.out
#SBATCH --error=slurm.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=dominik.muetter@uni-wuppertal.de
#SBATCH --partition=local
#
#SBATCH --job-name=masterthesis_porosityAnalysis_60kg/m3_simulation
#SBATCH --time=3-00:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=64
#SBATCH --mem=100G
#SBATCH --dependency=afterany:431

source /usr/lib/openfoam/openfoam2506/etc/bashrc

#rm -rf 0
#cp -r 0-orig 0
#decomposePar -force
mpirun -np 64 potentialFoam -parallel -writePhi -writep -writephi -initialiseUBCs
mpirun -np 64 simpleFoam -parallel
reconstructPar -latestTime
