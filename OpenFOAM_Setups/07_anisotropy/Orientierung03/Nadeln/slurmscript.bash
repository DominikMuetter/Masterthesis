#!/bin/bash
#
#SBATCH --output=slurm.%j.out
#SBATCH --error=slurm.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=dominik.muetter@uni-wuppertal.de
#SBATCH --partition=local
#
#SBATCH --job-name=masterthesis_anisotropy_orientation03_needles_simulation
#SBATCH --time=1-24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --mem=50G

source /usr/lib/openfoam/openfoam2506/etc/bashrc

rm -rf 0
cp -r 0-orig 0
decomposePar -force
mpirun -np 32 potentialFoam -parallel -writePhi -writep -writephi -initialiseUBCs
mpirun -np 32 simpleFoam -parallel
reconstructPar -latestTime
