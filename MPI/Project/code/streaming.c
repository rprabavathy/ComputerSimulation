#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <mpi.h>
#include <string.h>
#include "streaming.h"  /* Include the header here, to obtain the function declaration */
#include "input.h"

void streaming(Cell *cellNode, int localNodesX, int rank, int numprocs, MPI_Datatype MPI_MY_CELL_DATATYPE) {
	
	Cell *tempTop = malloc(NODES_Y * sizeof(Cell));
	Cell *tempBottom = malloc(NODES_Y * sizeof(Cell));
	
	/*	
	
	// Blocking Communication
	if(rank<numprocs-1){
			MPI_Send(&cellNode[(localNodesX - 1) * NODES_Y], NODES_Y, MPI_MY_CELL_DATATYPE, rank + 1, 0, MPI_COMM_WORLD);
			MPI_Recv(tempBottom, NODES_Y, MPI_MY_CELL_DATATYPE, rank + 1, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
		
		}
		// Start non-blocking communication for boundary rows 0
		if(rank>0){
			MPI_Recv(tempTop, NODES_Y, MPI_MY_CELL_DATATYPE, rank - 1 , 0, MPI_COMM_WORLD,MPI_STATUS_IGNORE);
			MPI_Send(&cellNode[0], NODES_Y, MPI_MY_CELL_DATATYPE, rank - 1 , 0, MPI_COMM_WORLD);
		}

	*/
	
	MPI_Request Tsreq, Trreq;
    MPI_Request Bsreq, Brreq;
	
    // Start non-blocking communication for boundary rows 0 and  m-1
	if(rank<numprocs-1){
		MPI_Isend(&cellNode[(localNodesX - 1) * NODES_Y], NODES_Y, MPI_MY_CELL_DATATYPE, rank + 1, 0, MPI_COMM_WORLD, &Tsreq);
        MPI_Irecv(tempBottom, NODES_Y, MPI_MY_CELL_DATATYPE, rank + 1, 0, MPI_COMM_WORLD, &Brreq);
	
	}
    if(rank>0){
	    MPI_Irecv(tempTop, NODES_Y, MPI_MY_CELL_DATATYPE, (rank - 1 + numprocs) % numprocs, 0, MPI_COMM_WORLD, &Trreq);
        MPI_Isend(&cellNode[0], NODES_Y, MPI_MY_CELL_DATATYPE, (rank - 1 + numprocs) % numprocs, 0, MPI_COMM_WORLD, &Bsreq);
    }
	
    // Wait for communication to finish
    if(rank<numprocs-1){
        MPI_Wait(&Tsreq, MPI_STATUS_IGNORE);
        MPI_Wait(&Brreq, MPI_STATUS_IGNORE);
    }
    if(rank>0){
        MPI_Wait(&Bsreq, MPI_STATUS_IGNORE);
        MPI_Wait(&Trreq, MPI_STATUS_IGNORE);
    }	

    Cell *nodeCpy = malloc(localNodesX * NODES_Y * sizeof(Cell));
    memcpy(nodeCpy, cellNode, localNodesX * NODES_Y * sizeof(Cell));
	
	  
    // Propagate particles simultaneously to their nearest neighbor nodes
	for (int x = 1; x < localNodesX-1 ; ++x) {
        for (int y = 1; y < NODES_Y-1; ++y) {
            int globalX = rank * localNodesX + x;
            int currIndex = y + NODES_Y * x ;
            if(cellNode[currIndex].fluid == 1){
                for (int d = 0; d < NUM_DIRECTIONS; ++d) {
                    int nbIndex=0;
                    if (isEven(globalX)) { // Even Rows
                        nbIndex = (y + evenDirections[d][1]) + NODES_Y * (x + evenDirections[d][0]);
                    } else {    // Odd Rows 
                        nbIndex = (y + oddDirections[d][1]) + NODES_Y * (x + oddDirections[d][0]);
                    }
                    if(cellNode[nbIndex].fluid == 1 || cellNode[nbIndex].fluid == 2){ // fluid or Dirichlet
                        cellNode[currIndex].particles[d] = nodeCpy[nbIndex].particles[d];
                    }else if(cellNode[nbIndex].fluid == 3){ // Slip Boundary
                        int opp = (d+3+NUM_DIRECTIONS) % NUM_DIRECTIONS;
                        if(globalX - 1 == 0){ // Upper Triangular
                            int rotation = isEven(opp)? 2 : -2; //rotate 120 or -120 degree
                            cellNode[currIndex].particles[(opp + rotation + NUM_DIRECTIONS) % NUM_DIRECTIONS] = nodeCpy[currIndex].particles[opp];
                        }
                        if(globalX + 1 == NODES_X-1){ // Lower Triangular
                            int rotation = isEven(opp)? -2 : 2; //rotate 120 or -120 degree
                            cellNode[currIndex].particles[(opp + rotation + NUM_DIRECTIONS) % NUM_DIRECTIONS] = nodeCpy[currIndex].particles[opp];
                        }
                    }else if(cellNode[nbIndex].fluid == 0){ // NO slip boundary
                        cellNode[currIndex].particles[d] = nodeCpy[currIndex].particles[(d+3+NUM_DIRECTIONS) % NUM_DIRECTIONS];
                    }
                }
            }
        }  
    } 
	    
	if(rank > 0){
		int x = 0;
        int globalX = rank * localNodesX + x;
        for (int y = 1; y < NODES_Y-1; ++y) {
            int currIndex = y + NODES_Y * x ;
            if(cellNode[currIndex].fluid == 1){
                for (int d = 0; d < NUM_DIRECTIONS; ++d) {
                    int nbIndex=0;
                    if (isEven(globalX)) { // Even Rows
						nbIndex = (y + evenDirections[d][1]) + (NODES_Y * (x + evenDirections[d][0]));
					} else {
                        nbIndex = (y + oddDirections[d][1]) + NODES_Y * (x + oddDirections[d][0]);
					}
                    // Bottom facing direction will have its neighbors in the previous processor last row , 
                    // which is stored in tempTop
                    if(d == 4 || d == 5){
                        if(nbIndex < 0){
                            nbIndex = nbIndex + NODES_Y;
                        }
                        if(tempTop[nbIndex].fluid == 1 || tempTop[nbIndex].fluid == 2){ // fluid or Dirichlet
                            cellNode[currIndex].particles[d] = tempTop[nbIndex].particles[d];
                        }else if(tempTop[nbIndex].fluid == 0){ // No slip boundary
                            cellNode[currIndex].particles[d] = nodeCpy[currIndex].particles[(d+3+NUM_DIRECTIONS) % NUM_DIRECTIONS];
                        }
                    }else{
                        if(cellNode[nbIndex].fluid == 1 || cellNode[nbIndex].fluid == 2){ // fluid or Dirichlet
                            cellNode[currIndex].particles[d] = nodeCpy[nbIndex].particles[d];
                        }else if(cellNode[nbIndex].fluid == 0){ // No slip boundary
                            cellNode[currIndex].particles[d] = nodeCpy[currIndex].particles[(d+3+NUM_DIRECTIONS) % NUM_DIRECTIONS];
                        }
                    }
                }
            }
        }
	}
	
	if(rank < numprocs-1){
        int x = localNodesX-1;
        int globalX = rank * localNodesX + x;
        for (int y = 1; y < NODES_Y-1; ++y) {
	        int currIndex = y + NODES_Y * x ;
		    if(cellNode[currIndex].fluid == 1){
				for (int d = 0; d < NUM_DIRECTIONS; ++d) {
		            int nbIndex=0;
                    if (isEven(globalX)) { // Even Rows
						nbIndex = (y + evenDirections[d][1]) + NODES_Y * (x + evenDirections[d][0]);
					} else {    // Odd Rows 
                        nbIndex = (y + oddDirections[d][1]) + NODES_Y * (x + oddDirections[d][0]);
					}
                    // top facing direction will have its neighbors in the next processor first row , 
                    // which is stored in tempBottom
                    if(d == 1 || d == 2){  
                        if(nbIndex >= localNodesX*NODES_Y){
                            nbIndex = nbIndex - localNodesX*NODES_Y;
                        }
                        
                        if(tempBottom[nbIndex].fluid == 1 || tempBottom[nbIndex].fluid == 2){ // fluid or Dirichlet
                            cellNode[currIndex].particles[d] = tempBottom[nbIndex].particles[d];
                        }else if(tempBottom[nbIndex].fluid == 0){ // No slip boundary
                            cellNode[currIndex].particles[d] = nodeCpy[currIndex].particles[(d+3+NUM_DIRECTIONS) % NUM_DIRECTIONS];
                        }
                    }else{
                        if(cellNode[nbIndex].fluid == 1 || cellNode[nbIndex].fluid == 2){ // fluid or Dirichlet
                            cellNode[currIndex].particles[d] = nodeCpy[nbIndex].particles[d];
                        }else if(cellNode[nbIndex].fluid == 0){ // No slip boundary
                            cellNode[currIndex].particles[d] = nodeCpy[currIndex].particles[(d+3+NUM_DIRECTIONS) % NUM_DIRECTIONS];
                        }
                    }

                }
                   
            }
        }

    } 
    
    free(tempTop);
    free(tempBottom);
}

