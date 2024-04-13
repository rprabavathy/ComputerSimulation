/* -------------------------------------------------
 * Exercise 5.1 Gram Schmidt Process
 * Prabavathy Rajasekaran (2130757)
 * -------------------------------------------------
 * Read all the vectors x_0.dat .....x_9.dat
 * and construct orthogonal normalized basis 
 * b0.....b9 from x0....x9
 * compute dot product of basis vectors with vector y
 * --------------------------------------------------
 */
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <mpi.h>

# define numVectors 10
# define N 65536

 /* Read_vector */
void Read_vector(char* filename, float local_v[], int n_bar, int p, int my_rank){
    float* temp = (float*)malloc(n_bar * sizeof(float));
    MPI_Status status;

    if (my_rank == 0){
        char filepath[50];
        sprintf(filepath, "%s", filename);

        FILE *file = fopen(filepath, "rb");
        if (file == NULL) {
            fprintf(stderr, "Error opening file: %s\n", filepath);
            MPI_Abort(MPI_COMM_WORLD, 1);
        }

        for (int i = 0; i < n_bar; i++)
            fscanf(file, "%f", &local_v[i]);
        for (int q = 1; q < p; q++){
            for (int i = 0; i < n_bar; i++)
                fscanf(file, "%f", &temp[i]);
            MPI_Send(temp, n_bar, MPI_FLOAT, q, 0, MPI_COMM_WORLD);
        }
        fclose(file);
    } 
    else 
    {
        MPI_Recv(local_v, n_bar, MPI_FLOAT, 0, 0, MPI_COMM_WORLD, &status);
    }
    free(temp);
} 

/* Serial_dot */
float Serial_dot(float *x,float *y,int n){
   float  sum = 0.0;
   for (int i = 0; i < n; i++){
       sum = sum + x[i]*y[i];
   }
   return sum;
} 

/* Parallel_dot */
float Parallel_dot(float *local_x, float *local_y,int n_bar){
    float  local_dot, dot = 0.0;
    local_dot = Serial_dot(local_x, local_y, n_bar);
    MPI_Reduce(&local_dot, &dot, 1, MPI_FLOAT,MPI_SUM, 0, MPI_COMM_WORLD);
    MPI_Bcast(&dot, 1, MPI_INT, 0, MPI_COMM_WORLD);
    return dot;
} 

int main(int argc, char* argv[]) 
{
    int    n_bar;  /* = n/numprocs */
    float  dot;
    int    numprocs;
    int    rank;
    
    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &numprocs);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    
    double start = MPI_Wtime(); 
    n_bar = N/numprocs;
    
    float* local_x = (float*)malloc(n_bar * sizeof(float));
    float* local_y = (float*)malloc(n_bar * sizeof(float));
    float local_O[numVectors][n_bar];
    float dot_results[numVectors];
    float* temp = (float*)malloc(n_bar * sizeof(float));
	
	float time[numVectors];

    double dot_product =0.0;
    for(int i=0; i<n_bar; i++){
        local_x[i] = 0.0;
        local_y[i] = 0.0;
        for(int j =0; j<numVectors; j++){
            local_O[j][i] =0.0;
        }
    }
    // Read vector y
    Read_vector("/work/korzec/LAB2/ex5/y.dat", local_y, n_bar, numprocs, rank);
    // Read all x_%d vectors from files
    for (int i = 0; i < numVectors; i++) 
    {
        char filename[20];
        sprintf(filename, "/work/korzec/LAB2/ex5/x_%d.dat", i);
        Read_vector(filename, local_x, n_bar, numprocs, rank);
        //Gram Schmidt Process Start
		double start = MPI_Wtime();         
        for (int l = 0; l < n_bar; l++) 
            temp[l] = local_x[l];

        for(int j = 0; j < i; j++){
            double dot = Parallel_dot(temp,local_O[j],n_bar);
            for(int l = 0; l < n_bar; l++){
                temp[l] -= local_O[j][l]*dot;
            }
        }
        dot_product = Parallel_dot(temp, temp,n_bar);
        for (int l = 0; l < n_bar; l++){
            local_O[i][l] = temp[l]/sqrt(dot_product);
        }
		//Gram Schmidt Process end
		
        dot_results[i] = Parallel_dot(local_O[i], local_y, n_bar);
		
		double end = MPI_Wtime();
        time[i] = end-start;
    }
    

    /*for(int ii = 0; ii < numVectors; ii++){
            for(int jj=0; jj < numVectors; jj++){
                double testDot = Parallel_dot(local_O[ii], local_O[jj], n_bar);
                if(ii == jj && rank ==0){
                    printf(" vectors %d and %d are parallel and its dot product is %f\n",ii,jj,testDot);
                }else if(rank==0){
                    printf(" vectors %d and %d are perpendicular and its dot product is %f\n",ii,jj,testDot);
                }
        }
    }*/
   
    if (rank == 0){
		double sumTime = 0;
        for (int i = 0; i <numVectors; i++ ){
            printf("The dot product of resulting basis vector of x_%d.dat and y.dat is %f\n", i,dot_results[i]);
			sumTime += time[i];
        }
        printf("\nGram Schmidt Process Execution Time without considering file reading = %f\n",sumTime);
    }
    MPI_Finalize();
        
} /* main */
