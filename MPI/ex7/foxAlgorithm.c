#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mpi.h>
#include <math.h>

// Matrix multiplication
void matrixMultiply(double *local_A, double *local_B, double *local_C, int n_bar){
        for (int i = 0; i < n_bar; i++) {
            for (int j = 0; j <n_bar; j++) {
                for (int k = 0; k < n_bar; k++) {
                    local_C[j + n_bar * i] += local_A[k + n_bar * i] * local_B[j + n_bar * k];
                }
            }
        }
}
void fox_algorithm(int n_bar, double *local_A, double *local_B, double *local_C, int q, int my_rank) {
    int rowCommRank, colCommRank;
    MPI_Comm row_comm, col_comm;
    MPI_Status status;
    
    // compute row/column index of process(ri,ci)
    int ci = my_rank % q;
    int ri = (my_rank-ci)/q;
    // computing the row rank of the process(ri,ci)
    MPI_Comm_split(MPI_COMM_WORLD, ri, my_rank, &row_comm);
    MPI_Comm_rank(row_comm, &rowCommRank);
    // computing the row rank of the process(ri,ci)
    MPI_Comm_split(MPI_COMM_WORLD, ci, my_rank, &col_comm);
    MPI_Comm_rank(col_comm, &colCommRank);
    
    int dest = (ri - 1 + q) % q;
	int source = (ri + 1) % q;

    double* tempA = malloc(n_bar*n_bar*sizeof(double));
    
    // Fox algorithm
    for (int stage = 0; stage < q; stage++) {
        int kbar = (ri + stage) % q;
        
        if (kbar == rowCommRank){
            MPI_Bcast(local_A, n_bar*n_bar, MPI_DOUBLE, kbar, row_comm);
			matrixMultiply(local_A, local_B, local_C,n_bar);
		}else{
            MPI_Bcast(tempA, n_bar*n_bar, MPI_DOUBLE, kbar, row_comm);
			matrixMultiply(tempA, local_B, local_C,n_bar);
		}

        // Circular shift of local_B in each process column
        MPI_Sendrecv_replace(local_B, n_bar * n_bar, MPI_DOUBLE, dest, 0, source, 0, col_comm, &status);
    }
    free(tempA);
}


int main(int argc, char *argv[]) {
    int myRank,nprocs;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &myRank);
    MPI_Comm_size(MPI_COMM_WORLD, &nprocs);

    int n;
    // Read the matrices A and B
    FILE* matrixA;
    FILE* matrixB;

    if(myRank == 0){
        matrixA = fopen("/work/korzec/LAB2/ex7/A.txt", "r");
        matrixB = fopen("/work/korzec/LAB2/ex7/B.txt", "r");
        // Read the size of the matrices
        fscanf(matrixA, "%d", &n);
        fscanf(matrixA, "%d", &n);
        fscanf(matrixB, "%d", &n);
        fscanf(matrixB, "%d", &n);
    }
        
    // Broadcast sizes of matrices
    MPI_Bcast(&n, 1, MPI_INT, 0, MPI_COMM_WORLD);
    
    // q*q blocks of size n_bar*n_bar
    int q = sqrt(nprocs);
    MPI_Bcast(&q, 1, MPI_INT, 0, MPI_COMM_WORLD);

    int n_bar = n / q;
    MPI_Bcast(&n_bar, 1, MPI_INT, 0, MPI_COMM_WORLD);


    double* local_A = malloc(n_bar * n_bar * sizeof(double));
    double* local_B = malloc(n_bar * n_bar * sizeof(double));
    double* local_C = calloc(n_bar * n_bar, sizeof(double));
    
    double * local_tmp_A = malloc(n_bar*n_bar*sizeof(double));
    double * local_tmp_B = malloc(n_bar*n_bar*sizeof(double));
        
        if (myRank == 0){
            int grid, dest;
            for (int i = 0; i < n; i++){
                for(int gc = 0; gc < q; gc++){
                    grid = i/n_bar + gc;
                    dest =(i/n_bar)*q+ gc%n_bar;
                    if(grid == 0){
                        for(int j = 0; j < n_bar; j++){
                            fscanf(matrixA,"%lf",&local_A[i*n_bar + j]);
                            fscanf(matrixB,"%lf",&local_B[i*n_bar + j]);
                        }
                    }else{
                        for(int j = 0; j < n_bar; j++){
                            fscanf(matrixA,"%lf",&local_tmp_A[j]);
                            fscanf(matrixB,"%lf",&local_tmp_B[j]);
                        }
                        MPI_Send(local_tmp_A,n_bar,MPI_DOUBLE,dest,dest,MPI_COMM_WORLD);
                        MPI_Send(local_tmp_B,n_bar,MPI_DOUBLE,dest,dest,MPI_COMM_WORLD);
                    }
                } 
            }
            free(local_tmp_A);
            free(local_tmp_B);
            fclose(matrixA);
            fclose(matrixB);
        }
        

        if(myRank>0){
            for(int j = 0; j < n_bar; j++){
                MPI_Recv(&local_A[j*n_bar], n_bar, MPI_DOUBLE, 0, myRank, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
                MPI_Recv(&local_B[j*n_bar], n_bar, MPI_DOUBLE, 0, myRank, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            }
                
        }
    // Perform matrix multiplication using the Fox algorithm
    fox_algorithm(n_bar, local_A, local_B, local_C, q, myRank);
    
    // Write the result matrix to file
    if (myRank == 0) {
        FILE *matrixC = fopen("C.txt", "w");
        if (matrixC == NULL) {
            perror("Error opening file");
            exit(EXIT_FAILURE);
        }

        fprintf(matrixC, "%d\n%d\n", n, n);
        double* temp = malloc(n_bar*sizeof(double));
        int grid, dest;
        for (int i = 0; i < n; i++){
            for(int gc = 0; gc < q; gc++){
                grid = i/n_bar + gc;
                dest =(i/n_bar)*q+ gc%n_bar;
                if(grid == 0){
                    for(int j = 0; j < n_bar; j++){
                        fprintf(matrixC,"%lf\n",local_C[i*n_bar + j]);
                    }
                }else{
                    MPI_Recv(temp,n_bar,MPI_DOUBLE,dest,dest,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
                    for(int j = 0; j < n_bar; j++){
                        fprintf(matrixC,"%lf\n",temp[j]);
                    }
                } 
            }
        }
        free(temp);
        fclose(matrixC);
    }

    if(myRank>0){
        for(int j = 0; j < n_bar; j++){
            MPI_Send(&local_C[j*n_bar], n_bar, MPI_DOUBLE, 0, myRank, MPI_COMM_WORLD);
        }    
    }
    MPI_Finalize();

    return 0;
}