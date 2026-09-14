#!/bin/bash
#
#SBATCH --output=slurm.%j.out
#SBATCH --error=slurm.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=dominik.muetter@uni-wuppertal.de
#SBATCH --partition=local
#
#SBATCH --job-name=masterthesis_meshStudy_01
#SBATCH --time=0-3:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --mem=2G

source /usr/lib/openfoam/openfoam2506/etc/bashrc

#decomposePar
mpirun -np 8 potentialFoam -parallel
mpirun -np 8 simpleFoam -parallel
reconstructPar -time 500,1000
