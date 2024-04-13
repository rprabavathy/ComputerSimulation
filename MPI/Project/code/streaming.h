#ifndef STREAMING_H_
#define STREAMING_H_

#include "input.h"
#include <mpi.h>

void streaming(Cell *node, int localX , int rank, int numprocs, MPI_Datatype MPI_MY_CELL_DATATYPE);

#endif

