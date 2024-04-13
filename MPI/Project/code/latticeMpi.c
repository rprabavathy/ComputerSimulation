#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <mpi.h>
#include "collision.h"
#include "streaming.h"
#include "input.h"

int main(int argc, char **argv) {
    int rank, numprocs;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &numprocs);
    MPI_Status status;

    double start = MPI_Wtime();
    int localNodesX = NODES_X / numprocs;
    int cl = 6;
    MPI_Datatype MPI_MY_CELL_DATATYPE;
    int lengths[6] = {1,1,1,1,2,6};
    MPI_Aint displacements[6] = { offsetof(Cell, index), offsetof(Cell, value),offsetof(Cell, fluid),offsetof(Cell, mass),offsetof(Cell, velocity[0]),offsetof(Cell, particles[0])};
    MPI_Datatype types[6] = { MPI_INT, MPI_INT, MPI_INT, MPI_INT, MPI_DOUBLE, MPI_CHAR};  
    MPI_Type_create_struct(cl, lengths, displacements, types, &MPI_MY_CELL_DATATYPE);
    MPI_Type_commit(&MPI_MY_CELL_DATATYPE);
  
    MPI_Datatype newtype;
    MPI_Type_create_resized(MPI_INT, 0L, sizeof(Cell), &newtype);
    MPI_Type_commit(&newtype);

    MPI_Datatype velocityType;
    MPI_Type_create_resized(MPI_DOUBLE, 0L, sizeof(Cell), &velocityType);
    MPI_Type_commit(&velocityType);

    // Input Grid
    Cell* inputCell = calloc(localNodesX * NODES_Y, sizeof(Cell));
    for(int x = 0; x < localNodesX; ++x){
        for(int y = 0; y < NODES_Y; ++y){
            memset(inputCell[y + NODES_Y * x].particles, '0', sizeof(inputCell[y + NODES_Y*x].particles));
        }
    }
    
    initializeGrid(inputCell, localNodesX, rank);
    for (int t = 0; t < NSTEPS; ++t){
       collision(inputCell, localNodesX);
       
       streaming(inputCell, localNodesX, rank, numprocs, MPI_MY_CELL_DATATYPE);
      
       updateNodewithMassAndVelocity(inputCell, localNodesX);
    
	}
	
	MPI_Barrier(MPI_COMM_WORLD);
    double end = MPI_Wtime();

    if(rank == 0)
        printf("\n Execution Time : %f seconds\n", end-start);
    
    free(inputCell);
    free(velocityType);
    free(newtype);
    free(MPI_MY_CELL_DATATYPE);

    MPI_Finalize();

    return 0;
}
