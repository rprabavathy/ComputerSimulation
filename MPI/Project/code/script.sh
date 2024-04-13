#!/bin/bash
# Define the range of processes
processes=(1 2 4 5 10 20 25 50 100)

# Submit the SLURM jobs
for p in "${processes[@]}"; do
    
	if [ "$p" -ge 1 ] && [ "$p" -le 20 ]; then
        nodes=1
        ntasks_per_node=$((p / nodes))
	else
        nodes=5
        ntasks_per_node=$((p / nodes))
    fi

    # Create a separate SLURM submission script
    submission_script="submit_${p}.sh"

    echo "#!/bin/bash" > $submission_script
    echo "#SBATCH --partition=compute2011" >> $submission_script
    echo "#SBATCH --exclusive" >> $submission_script
    echo "#SBATCH --nodes=$nodes" >> $submission_script
    echo "#SBATCH --ntasks-per-node=$ntasks_per_node" >> $submission_script
    echo "#SBATCH --output=./output_${p}.out" >> $submission_script
    echo "#SBATCH --error=./error_${p}.err" >> $submission_script
    echo "" >> $submission_script
    echo "module load mpi/openmpi/4.1.0" >> $submission_script
    echo "mpirun ./latticeGas " >> $submission_script

    # Submit the SLURM job and wait for completion
    sbatch --wait $submission_script
done
