/* Exercise 9 : Advanced MPI
 *  Prabavathy Rajasekaran (2130757)
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mpi.h>
# define k 0.1 // kappa value

void smearMatrix(double *localA, double *localB, int m, int N, int rank, int numprocs) {

    MPI_Request Tsreq, Trreq;
    MPI_Request Bsreq, Brreq;
    MPI_Status stat;
        
    double *tempTop = malloc(N*sizeof(double));
    double *tempBottom = malloc(N*sizeof(double));
    
    // Start non-blocking communication for boundary rows m-1
    MPI_Isend(&localA[(m - 1) * N], N, MPI_DOUBLE, (rank + 1) % numprocs, 0, MPI_COMM_WORLD, &Tsreq);
    MPI_Irecv(tempTop, N, MPI_DOUBLE, (rank - 1 + numprocs) % numprocs, 0, MPI_COMM_WORLD, &Trreq);

    // Start non-blocking communication for boundary rows 0
    MPI_Isend(&localA[0], N, MPI_DOUBLE, (rank - 1 + numprocs) % numprocs, 0, MPI_COMM_WORLD, &Bsreq);
    MPI_Irecv(tempBottom, N, MPI_DOUBLE, (rank + 1) % numprocs, 0, MPI_COMM_WORLD, &Brreq);

    // Compute rows i in the local B matrix while communication is ongoing
    for (int i = 1; i < m - 1; ++i) {
        for (int j = 0; j < N; ++j) {
           double neighbors = (localA[(i - 1) * N + j] + localA[(i + 1) * N + j] +
                                localA[i * N + (j + 1) % N] + localA[i * N + (j - 1 + N) % N]);
            localB[i * N + j] = (1.0 / (1.0 + 4.0 * k)) * (localA[i * N + j] + k * neighbors);
        }
    }

    // Wait for communication to finish
     MPI_Wait(&Bsreq, &stat);
     MPI_Wait(&Brreq, &stat);
	 MPI_Wait(&Tsreq, &stat);
     MPI_Wait(&Trreq, &stat);

    //Compute row 0 in the local B matrix
    int i = 0;
    for (int j = 0; j < N; ++j) {
        double neighbors = (tempTop[j] + localA[1 * N + j] +
                            localA[i * N + (j + 1) % N] + localA[i * N + (j - 1 + N) % N]);
        localB[i * N + j] = (1.0 / (1.0 + 4.0 * k)) * (localA[i * N + j] + k * neighbors);
    }
    // compute row  m - 1 in the local B matrix
    i = m - 1;
    for (int j = 0; j < N; ++j) {
        double neighbors = (localA[(m - 2) * N + j] + tempBottom[j] +
                    localA[i * N + (j + 1) % N] + localA[i * N + (j - 1 + N) % N]);
        localB[i * N + j] = (1.0 / (1.0 + 4.0 * k)) * (localA[i * N + j] + k * neighbors);
    }

    free(tempTop);
    free(tempBottom);
}


int prod(int *vec, int dim){
    int i;
    int val = 1;
    for (i = 0; i < dim; i++)
        val *= vec[i];
    return (val);
}

int main(int argc, char* argv[]){
    int rank , numprocs;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &numprocs);
    // parameters for cartesian communication grid
    int ndims = 2; 
    int dims[2] = {numprocs,1};
    int periods[2] = {1,1};
    MPI_Comm cart_comm;
    int cart_rank;
    int coords[2];

    if (numprocs != prod(dims, ndims))
        MPI_Abort(MPI_COMM_WORLD, -1);
   
    // create communictor with cartesian topology
    MPI_Cart_create(MPI_COMM_WORLD, ndims, dims, periods, 0, &cart_comm);
    MPI_Comm_rank(cart_comm, &cart_rank);

    // get position in cartesian process grid
    MPI_Cart_coords(cart_comm, cart_rank, ndims, coords);

    MPI_Status status;
    MPI_Datatype subblock;
    MPI_File matrixA;

    // Matrix Parameters
    int M, N , lm,ln;  // = (512 & 736 ) , lm = m/numprocs;
    
    int mpi_error = MPI_File_open(cart_comm, "/work/korzec/LAB2/ex9/matrix.bin", MPI_MODE_RDONLY, MPI_INFO_NULL, &matrixA);
	if (mpi_error != MPI_SUCCESS) {
        fprintf(stderr, "Error opening file %s : %d\n", "matrix.bin", mpi_error);
        MPI_Abort(MPI_COMM_WORLD, mpi_error);
    }
    // Read global dimensions
    MPI_File_read_at(matrixA, 0, &M, 1, MPI_INT, &status);
    MPI_File_read_at(matrixA, 1*sizeof(int), &N, 1, MPI_INT, &status);
    // allocate local data array
    lm = M/dims[0]; // 512/16 = 32
    ln = N/dims[1];   // 736/1 = 736
    double* localA = malloc(lm*ln*sizeof(double));
    double* localB = malloc(lm*ln*sizeof(double));
    int sizes[2], lsizes[2], starts[2];
    // create a sub-array type for parallel I/O
    sizes[0]=M;
    sizes[1]=N;
    lsizes[0]=lm;
    lsizes[1]=ln;
    starts[0]=coords[0]*lm;
    starts[1]=coords[1]*ln;

    MPI_Type_create_subarray(2,sizes,lsizes,starts,MPI_ORDER_C,MPI_DOUBLE,&subblock);
    MPI_Type_commit(&subblock);
    
    MPI_File_set_view(matrixA, 2*sizeof(int), MPI_DOUBLE, subblock, "native", MPI_INFO_NULL);
    MPI_File_read_all(matrixA, localA, lm*ln, MPI_DOUBLE, &status);
    MPI_Barrier(MPI_COMM_WORLD);
    MPI_File_close(&matrixA);

    for (int iteration = 1; iteration <= 100; ++iteration) {
		// Perform smearing operation with latency hiding
        smearMatrix(localA, localB, lm, N, rank, numprocs);
        // Copy the smeared result back to the original matrix for the next iteration
        memcpy(localA, localB, lm * ln * sizeof(double));
        // Write the final matrix to file in parallel
        if(iteration == 5 || iteration == 20 || iteration == 100){
            char filename[20];
            sprintf(filename, "N%dalpha0_1.bin",iteration);
            MPI_File smearMatrix;
            int mpi_error = MPI_File_open(MPI_COMM_WORLD, filename, MPI_MODE_WRONLY | MPI_MODE_CREATE, MPI_INFO_NULL, &smearMatrix);
            if (mpi_error != MPI_SUCCESS) {
                fprintf(stderr, "Error opening file %s : %d\n" , filename , mpi_error);
                MPI_Abort(MPI_COMM_WORLD, mpi_error);
            }
            MPI_File_write_at(smearMatrix, 0, &M, 1, MPI_INT, &status);
            MPI_File_write_at(smearMatrix, 1*sizeof(int), &N, 1, MPI_INT, &status);
            MPI_File_set_view(smearMatrix, 2*sizeof(int), MPI_DOUBLE, subblock, "native", MPI_INFO_NULL);
            //write its own piece of data to file
            MPI_File_write_all(smearMatrix, localA, lm*ln, MPI_DOUBLE, &status);
            MPI_File_close(&smearMatrix);
            MPI_Barrier(MPI_COMM_WORLD);
        }
        
    }
    MPI_Finalize();
}
