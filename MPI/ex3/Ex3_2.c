/* Exercise 3.2 Tree Structure
 * Prabavathy Rajasekaran (2130757)
 * ------------------------------------------------
 * Tree Based Communication
 * ------------------------------------------------
 * Compare the Execution time of the Built-In MPI
 * Library with the custom broadcast Tree implementation
 * -------------------------------------------------
 */
#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
int my_Bcast_Tree(void *buffer, int count, MPI_Datatype datatype, int root, MPI_Comm comm) {
    int rank, numprocs;
    MPI_Status status;
    MPI_Comm_rank(comm, &rank);
    MPI_Comm_size(comm, &numprocs);

    int k = 0, power = 1;
    // Find the smallest k such that numprocs <= 2^k
    while (power < numprocs) {
        power *= 2;
        k++;
    }
    
    for (int i = k; i > 0; i--) {
        int mask = (1 << (i - 1));
        int source = (rank - mask + numprocs) % numprocs;
        int dest = (rank + mask) % numprocs;
        if ((rank % (1 << i)) == root && dest != root) {
	    MPI_Send(buffer, count, datatype, dest, 123, MPI_COMM_WORLD);
        } else if ((rank % (1 << i)) == root+mask)  {
            MPI_Recv(buffer, count, datatype, source, 123, MPI_COMM_WORLD, &status);
            printf("Process %d received a message from process %d.\n", rank, source);
        }
        
        MPI_Barrier(comm);
    }
    return MPI_SUCCESS;
}

int main(int argc, char* argv[]){
    int rank, numprocs;
    
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &numprocs);

    const int N = 100000;
    double* data = (double*)malloc(N * sizeof(double));

    if (rank == 0) {
        for (int i = 0; i< N; i++) {
            data[i] = i;
        }
    }
    // Using built-in broadcast
    double start = MPI_Wtime();
    MPI_Bcast(data, N, MPI_DOUBLE, 0, MPI_COMM_WORLD); 
    MPI_Barrier(MPI_COMM_WORLD);
    double end = MPI_Wtime();

    if(rank == 0)
  	    printf("Execution time of Built-In : %f\n\n", end-start);

    double* data1 = (double*)malloc(N * sizeof(double));

    if (rank == 0){ 
        for (int i = 0; i< N; i++) 
            data1[i] = i;
    }

    // Now, using custom broadcast function Tree-like Structure
    double start1 = MPI_Wtime();
    my_Bcast_Tree(data1, N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
    MPI_Barrier(MPI_COMM_WORLD);
    double end1 = MPI_Wtime();

    // Verify that data is correctly broadcasted and print the Execution time
    int correct = 1;
    for (int i = 0; i < N; i++) {
        if (data1[i] != i) {
            correct = 0;
            break;
        }
    }
    if(rank == 0){
        if(correct){
            printf("\n Broadcast successful!\n");
            printf("\nExecution time of own function : %f\n", end1-start1);
        }else{
            printf("\n Broadcast Failed!\n");
            printf("\nExecution time of own function : %f\n", end1-start1);
        }
    }
    free(data);
    free(data1);    
    MPI_Finalize();

}
