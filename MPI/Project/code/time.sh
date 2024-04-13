#!/bin/bash

# Define the range of processes
processes=(1 2 4 5 10 20 25 50 100)

echo "No_Of_Process, Execution_time" > timeResult.csv

# Collect results for each job
for p in "${processes[@]}"; do
    execution_time=$(grep " Execution Time : " output_${p}.out | awk '{print $4}')
    echo "$p, $execution_time" >> timeResult.csv
done
