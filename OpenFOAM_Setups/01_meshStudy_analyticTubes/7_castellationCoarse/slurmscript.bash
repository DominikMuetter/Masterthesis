#!/bin/bash
#
#SBATCH --output=slurm.%j.out
#SBATCH --error=slurm.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=dominik.muetter@uni-wuppertal.de
#SBATCH --partition=local
#
#SBATCH --job-name=masterthesis_meshStudy_7
#SBATCH --time=0-20:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --mem=10G

source /usr/lib/openfoam/openfoam2506/etc/bashrc

#decomposePar
mpirun -np 16 potentialFoam -parallel -writePhi -writep -writephi -initialiseUBCs
mpirun -np 16 simpleFoam -parallel
reconstructPar -latestTime
