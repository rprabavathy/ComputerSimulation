/* -------------------------------------------------
 * Exercise 4.1 Lattice Walk
 * Prabavathy Rajasekaran (2130757)
 * -------------------------------------------------
 * Read a sequence of directions from directions.dat
 * move through the lattice and sum up the process 
 * ranks and print.
 * directions   0 - positive xo (move right) - (1,0)
 * 	            1 - positive x1 (move up) - (0,1)
 * 	            2 - negative xo (move left) (-1,0)
 * 	            3 - negative x1 (move down) (0,-1)
 * -------------------------------------------------
 */
#include <stdio.h>
#include <mpi.h>

#define GRIDSIZE 8
#define DIRECTIONS 4

// Directions : Right, Top, Left and Bottom
static const int x0_N[DIRECTIONS] = {1, 0, -1, 0} , x1_N[DIRECTIONS] = {0, 1, 0, -1};

// Compute the Neighbor's Rank for a given direction
int findNeighbors(int process,int direction){
    int next_x0 = ((process % GRIDSIZE) + x0_N[direction] + GRIDSIZE) % GRIDSIZE;
    int next_x1 = ((process / GRIDSIZE) + x1_N[direction] + GRIDSIZE) % GRIDSIZE;
    
    return next_x0 + next_x1 * GRIDSIZE;
}

int main(int argc, char* argv[]){

    MPI_Init(&argc, &argv); // Initialize MPI 
    int rank; // Process rank who am i ?
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    //int numprocs; // Total no of process
    //MPI_Comm_size(MPI_COMM_WORLD, &numprocs);
    MPI_Status status; 
    FILE* fp;

    // Rank 0 allowed to do I/O Operations
    if(rank == 0)
        fp = fopen("directions.dat", "r");
    
    int finished = 0; // to check whether the file is processed fully
    
    int pos=0 , value = 0;
    while(!finished){
        // Every Rank should know its 4 neighbors
        int neighbors[DIRECTIONS];
        for (int i = 0; i < DIRECTIONS; i++)
            neighbors[i] = findNeighbors(rank,i);
        
        int direction;
        // Rank 0 allowed to do I/O Operations
        if (rank == 0) {
            int readResult = fscanf(fp, "%d", &direction);
            finished = (readResult == EOF) ? 1 : 0;
        }

        MPI_Bcast(&finished, 1, MPI_INT, 0, MPI_COMM_WORLD);

        if (finished){
            break;
        }
    
        // Broadcast direction :: read from next line in file 
        MPI_Bcast(&direction, 1, MPI_INT, 0, MPI_COMM_WORLD); // root = 0

        // Compute the rank of my neighbor in the given direction
        int neighborRank;
        if(rank == pos)
            neighborRank = neighbors[direction];
        else
            neighborRank = findNeighbors(pos,direction);

        // Broadcast Neighbor rank in this direction
        MPI_Bcast(&neighborRank, 1, MPI_INT, pos, MPI_COMM_WORLD); // root = pos
        
        if(rank == pos){
            value += rank;
            MPI_Send(&value, 1, MPI_INT, neighborRank, 123, MPI_COMM_WORLD);
        }

        if(rank == neighborRank){
            MPI_Recv(&value, 1, MPI_INT, pos, 123, MPI_COMM_WORLD, &status);
        }
        pos = neighborRank;
    }

    // sending the final sum to process 0 as the proces 'pos' holds the updated sum
    if (rank == pos)
        MPI_Send(&value, 1, MPI_INT, 0, 123, MPI_COMM_WORLD);

    if (rank == 0){
        MPI_Recv(&value, 1, MPI_INT, pos, 123, MPI_COMM_WORLD, &status);
        printf("Sum of all encountered process ranks during lattice walk : %d\n", value);
        fclose(fp);
    }

    MPI_Finalize(); // Shutdown the MPI 
    return 0;
}