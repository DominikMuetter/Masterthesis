#!/bin/bash
#
#SBATCH --output=slurm.%j.out
#SBATCH --error=slurm.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=dominik.muetter@uni-wuppertal.de
#SBATCH --partition=local
#
#SBATCH --job-name=masterthesis_simulationNeedles_comparison_smoothedSurface4
#SBATCH --time=0-12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --mem=16G
#SBATCH --requeue

source /usr/lib/openfoam/openfoam2506/etc/bashrc

nice -n 19 mpirun -np 16 simpleFoam -parallel

reconstructPar -newTimes
