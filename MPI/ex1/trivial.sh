#!/bin/bash
echo > trivial.csv

echo "Task 1"
start=$(date +%S%N)
./trivial 0 100000000
end=$(date +%S%N)
echo "Elapsed Time: $(($end-$start)) nanoseconds"
echo "1,$(($end-$start))" >> trivial.csv

echo "Task2 "
start=$(date +%S%N)
./trivial 0 50000001 &
./trivial 50000001 100000000 &
wait  # don't measure the time before all background tasks finished
end=$(date +%S%N)
echo "Elapsed Time: $(($end-$start)) nanoseconds"
echo "2,$(($end-$start))" >> trivial.csv


echo "Task 3 "
start=$(date +%S%N)
./trivial 0 33000001 &
./trivial 33000001 66000001 &
./trivial 33000001 66000001 &
./trivial 66000001 100000000 &
wait  # don't measure the time before all background tasks finished
end=$(date +%S%N)
echo "Elapsed Time: $(($end-$start)) nanoseconds"
echo "3,$(($end-$start))" >> trivial.csv

echo "Task 4 "
start=$(date +%S%N)
./trivial 0 25000001 &
./trivial 25000001 50000001 &
./trivial 50000001 75000001 &
./trivial 75000001 100000000 &
wait  # don't measure the time before all background tasks finished
end=$(date +%S%N)
echo "Elapsed Time: $(($end-$start)) nanoseconds"
echo "4,$(($end-$start))" >> trivial.csv

echo "Task 5"
start=$(date +%S%N)
./trivial 0 20000001 &
./trivial 20000001 40000001 &
./trivial 40000001 60000001 &
./trivial 60000001 80000001 &
./trivial 80000001 100000000 &
wait  # don't measure the time before all background tasks finished
end=$(date +%S%N)
echo "Elapsed Time: $(($end-$start)) nanoseconds"
echo "5,$(($end-$start))" >> trivial.csv

echo "Task 6"
start=$(date +%S%N)
./trivial 0 16000001 &
./trivial 16000001 33000001 &
./trivial 33000001 50000001 &
./trivial 50000001 66000001 &
./trivial 66000001 83000001 &
./trivial 83000001 100000000 &
wait  # don't measure the time before all background tasks finished
end=$(date +%S%N)
echo "Elapsed Time: $(($end-$start)) nanoseconds"
echo "6,$(($end-$start))" >> trivial.csv

echo "Task 7"
start=$(date +%S%N)
./trivial 0 14285001 &
./trivial 14285001 28570001 &
./trivial 28570001 42855001 &
./trivial 42855001 57140001 &
./trivial 57140001 71425001 &
./trivial 71425001 85710001 &
./trivial 85710001 100000000 &

wait  # don't measure the time before all background tasks finished
end=$(date +%S%N)
echo "Elapsed Time: $(($end-$start)) nanoseconds"
echo "7,$(($end-$start))" >> trivial.csv

echo "Task 8"
start=$(date +%S%N)
./trivial 0 12500001 &
./trivial 12500001 25000001 &
./trivial 25000001 37500001 &
./trivial 37500001 50000001 &
./trivial 50000001 62500001 &
./trivial 62500001 75000001 &
./trivial 75000001 87500001 &
./trivial 87500001 100000000 &
wait  # don't measure the time before all background tasks finished
end=$(date +%S%N)
echo "Elapsed Time: $(($end-$start)) nanoseconds"
echo "8,$(($end-$start))" >> trivial.csv


echo "Task 9"
start=$(date +%S%N)
./trivial 0 11111111 &
./trivial 11111111 22222222 &
./trivial 22222222 33333333 &
./trivial 33333333 44444444 &
./trivial 44444444 55555555 &
./trivial 55555555 66666666 &
./trivial 66666666 77777777 &
./trivial 77777777 88888888 &
./trivial 88888888 100000000 &
wait  # don't measure the time before all background tasks finished
end=$(date +%S%N)
echo "Elapsed Time: $(($end-$start)) nanoseconds"
echo "9,$(($end-$start))" >> trivial.csv

echo "Task 10"
start=$(date +%S%N)
./trivial 0 10000001 &
./trivial 10000001 20000001 &
./trivial 20000001 30000001 &
./trivial 30000001 40000001 &
./trivial 40000001 50000001 &
./trivial 50000001 60000001 &
./trivial 60000001 70000001 &
./trivial 70000001 80000001 &
./trivial 80000001 90000001 &
./trivial 90000001 100000000 &
wait  # don't measure the time before all background tasks finished
end=$(date +%S%N)
echo "Elapsed Time: $(($end-$start)) nanoseconds"
echo "10,$(($end-$start))" >> trivial.csv