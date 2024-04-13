#!/bin/bash
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=16
#SBATCH --partition=compute2011
#SBATCH --exclusive
#SBATCH --output=./outputJob4.out
#SBATCH --error=./errorJob.err


module load mpi/openmpi/4.1.0
mpicc -o ex2 collective_mpi.c
mpirun ./ex2

