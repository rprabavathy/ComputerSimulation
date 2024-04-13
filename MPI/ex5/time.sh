#!/bin/bash

# Define the range of processes
processes=(1 2 4 8 16 32 64)

echo "No_Of_Process, Execution_time" > timeResult.csv

# Collect results for each job
for p in "${processes[@]}"; do
    execution_time=$(grep "Execution Time" output_${p}.out | awk '{print $NF}')
    echo "$p, $execution_time" >> timeResult.csv
done
