#!/bin/bash
#
#SBATCH --output=slurm.%j.out
#SBATCH --error=slurm.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=dominik.muetter@uni-wuppertal.de
#SBATCH --partition=local
#
#SBATCH --job-name=masterthesis_simulationNeedles_nonsmoothed
#SBATCH --time=2-12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --mem=24G
#SBATCH --requeue

source /usr/lib/openfoam/openfoam2506/etc/bashrc

#decomposePar -force

nice -n 19 mpirun -np 16 simpleFoam -parallel

reconstructPar -time 1000,2000
