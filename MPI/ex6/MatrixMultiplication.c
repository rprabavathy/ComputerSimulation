#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <mpi.h>

float* readMatrix(char* filename, int* rows, int* cols, int numprocs, int rank) {
    int m_bar;
    float *localMatrix;
    FILE *file;

    MPI_Status status;
    if (rank == 0) {
        file = fopen(filename, "rb");
        if (file == NULL) {
            fprintf(stderr, "Error opening file: %s\n", filename);
            MPI_Abort(MPI_COMM_WORLD, 1);
        }
        fscanf(file, "%d", rows);
        fscanf(file, "%d", cols);
        m_bar = *rows / numprocs;
    }
    MPI_Bcast(rows, 1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Bcast(cols, 1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Bcast(&m_bar, 1, MPI_INT, 0, MPI_COMM_WORLD);
    localMatrix = malloc(m_bar * (*cols) * sizeof(float));

    if(rank == 0){
      float *temp = malloc(m_bar * (*cols) * sizeof(float));
      for (int q = 0; q < numprocs; q++){
        for (int i = 0; i < m_bar; i++){
	        for (int j = 0; j < *cols; j++){
            if(q==0){ 
              fscanf(file, "%e", &localMatrix[j + (*cols) * i]);
	          }else{
	            fscanf(file, "%e", &temp[j + (*cols) * i]);
	          }
  	      } 
	      }
	      if(q!=0){
     	    MPI_Send(temp, m_bar * (*cols), MPI_FLOAT, q, 0, MPI_COMM_WORLD);
	      }
      }
      fclose(file);
	    free(temp);
    }
    else
    {
      MPI_Recv(localMatrix, m_bar * (*cols), MPI_FLOAT, 0, 0, MPI_COMM_WORLD, &status);
    }
    return localMatrix;
}

void WriteMatrix(char* filename, float *local_C, int rows, int cols, int numprocs, int rank) {
  int m_bar = rows / numprocs;
  MPI_Status status;
 
  if (rank == 0) {
    FILE *outputFile = fopen(filename, "wb");
    if (outputFile == NULL) {
      fprintf(stderr, "Error opening file: %s\n", filename);
      MPI_Abort(MPI_COMM_WORLD, 1);
    }

    fprintf(outputFile, "%d\n%d\n", rows, cols);
    for (int q = 0; q < numprocs; q++) {
      if(q!=0){
        MPI_Recv(local_C, m_bar * cols, MPI_FLOAT, q, 0, MPI_COMM_WORLD, &status);
      }
      for (int i = 0; i < m_bar; i++) {
        for (int j = 0; j < cols; j++) {
            fprintf(outputFile, "%e\n", local_C[j + cols * i]);
        }
      }
    }
    fclose(outputFile);
  }else{
    MPI_Send(local_C, m_bar * cols, MPI_FLOAT, 0, 0, MPI_COMM_WORLD);
  }   
}


/* Serial_dot */
float Serial_dot(float *x,float *y,int n){
   float  sum = 0.0;
    for (int i = 0; i < n; i++){
        sum = sum + x[i]*y[i];
    }
   return sum;
} 


float* ParallelMatrixMultiplication(float *local_A, float *local_B, int m_bar, int n_bar, int k, int numprocs, int rank) {
    
  float *local_C = malloc(m_bar * k  * sizeof(float));
  // Allocate temporary buffer to store the gathered B column
  int n = n_bar *numprocs;
  float *temp_B_col = malloc(n  * sizeof(float));
  float *temp_B = malloc(n_bar * sizeof(float));
  
  
	for(int col = 0; col < k; col++) {
		/* Gather individual elements of local_B across all processes */
		for(int i = 0; i < n_bar; i++) {
			temp_B[i] = local_B[i * k + col];
		}
		MPI_Allgather(temp_B, n_bar, MPI_FLOAT, temp_B_col, n_bar, MPI_FLOAT, MPI_COMM_WORLD);
		for (int j = 0; j < m_bar; j++){	
			//printf("rank :: %d Serial dot :: %e\n", rank,Serial_dot(&local_A [j * n_bar*numprocs], temp_B_col, n));
			local_C[j * k + col] = Serial_dot(&local_A [j * n_bar*numprocs], temp_B_col, n_bar*numprocs);
		}
	}
  free(temp_B);
  free(temp_B_col);
  return local_C;
}

int main(int argc, char* argv[]) {
    int rank, numprocs;

    float *local_A, *local_B,  *local_C;
    int m, n, k = 0;
    int m_bar, n_bar;

    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &numprocs);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    local_A = readMatrix("/work/korzec/LAB2/ex6/A.txt", &m, &n, numprocs, rank);
    local_B = readMatrix("/work/korzec/LAB2/ex6/B.txt", &n, &k, numprocs, rank);
    
    m_bar = m / numprocs;
    n_bar = n / numprocs;
    

    local_C = ParallelMatrixMultiplication(local_A,local_B,m_bar,n_bar,k,numprocs,rank);
    WriteMatrix("sample.txt", local_C, m_bar*numprocs, k, numprocs, rank); 
    
    free(local_A);
    free(local_B);
    free(local_C);
    MPI_Finalize();

    return 0;
}
