#!/bin/bash
#
#SBATCH --output=slurm.%j.out
#SBATCH --error=slurm.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=dominik.muetter@uni-wuppertal.de
#SBATCH --partition=local
#
#SBATCH --job-name=masterthesis_turbulenceModels_kOmegaSST-transient
#SBATCH --time=0-24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --mem=32G

source /usr/lib/openfoam/openfoam2506/etc/bashrc

decomposePar
mpirun -np 32 pimpleFoam -parallel
reconstructPar -latestTime
