/* Exercise 2.1 Collective Communication
 * Prabavathy Rajasekaran (2130757)
 * ------------------------------------------------
 * Find Mean, Variance, Maximum and Minimum of the 
 * data in each file containing 100 Integers and 
 * all of the data together ie., 64 files.
 * Record the execution time of the program 
 * with 1, 2, 4 and64 cores.
 * ------------------------------------------------
 * Input : data files data_n.dat 
 * output: Mean, Variance, Maximum and Minimum of 
 *         each data file 
 *         Global Mean, Global Variance, Global 
 *         Maximum and global Minimum of all files.
 *         Execution time of the program 
 * -------------------------------------------------
 */
#include <stdio.h>
#include <limits.h>
#include <mpi.h>
#define NUM_FILES 64/* Total no of files*/

int main(int argc, char *argv[])
{
    /* Rank of process and total no of process*/
    int rank, numprocs; 
    int N,Ntot=0; /* N - no of integers in a data file and Ntot - total no of integers in all the files*/
    
    double sum, sum_sq, tmp,x;  /* Variables required for each individual file*/
    double max = INT_MIN, min=INT_MAX ; /* Initialize the max and min before start of accessing files*/
    double gSum=0,gSum_sq=0,gMax = 0, gMin=0; /* Global Variables to calculate among all files*/
    
    /*  Start an MPI */
    MPI_Init(&argc, &argv); 
    /* process rank (Who am I) */
    MPI_Comm_rank(MPI_COMM_WORLD, &rank); 
    /* Total number of Processors */
    MPI_Comm_size(MPI_COMM_WORLD, &numprocs); 
    /* Wall-clock time code being timed between Start and End*/
    double start = MPI_Wtime(); 
    /* Looping all the data files */
    for(int n=0; n<NUM_FILES; n++){  
/* A rank n = n mod numprocs should process data files data_n.dat file */
        if(n%numprocs==rank){ 
            N=0;/* count of the integers present in each file */
            char fName[50]; /* File Name*/
            /* Data File Path */
            sprintf(fName, "server/data_%d.dat",n); 
            //sprintf(fName, "/archive/keep/Lab2/ex2/data_%d.dat",i);
            FILE* fp = fopen(fName, "r"); /* Open a File */
            if(fp!=NULL){
           /* Initialization of variables for each file */
            sum =0, sum_sq =0, max = INT_MIN, min=INT_MAX;
    /*calculating statistical measures on the fly*/
                while(fscanf(fp, "%lf", &tmp) != EOF) {
                    sum += tmp;
                    sum_sq += tmp*tmp;
                    if(tmp>max) max = tmp;
                    if(tmp<min) min = tmp;
                    ++ N;
                }        
/* Printing the corresponding output for each file*/
                printf("\nRank : %d of Process %d\n",rank,numprocs);
                printf("data_%d.dat: Mean=%f, Variance=%f, Min=%f, Max=%f\n", n, sum/N, (sum_sq-sum*sum/N)/(N-1), min, max);
            }
            fclose(fp); /* close the file*/
            /* Global variables calculation*/
            gSum+=sum;
            gSum_sq+=sum_sq;
            if(gMax == 0) gMax = max;
            else if(max>gMax) gMax = max;
            if(gMin == 0)  gMin = min;
            else if(min<gMin) gMin = min;
        }
    /* count no of integers in all the 64 data files*/
        Ntot += N;
    }

    /* Applying fan-in algorithm to find Global values of all the files */
    MPI_Reduce(&gSum, &x, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
    gSum = x;
    MPI_Reduce(&gSum_sq, &x, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
    gSum_sq = x;
    MPI_Reduce(&gMax, &x, 1, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);
    gMax = x;
    MPI_Reduce(&gMin, &x, 1, MPI_DOUBLE, MPI_MIN, 0, MPI_COMM_WORLD);
    gMin = x;
    double end = MPI_Wtime();

    /* Printing the final result*/
    if( rank==0 ){
        printf("\nTotal no of Integers in all data file = %d\n",Ntot);
        printf("Global : Mean=%f, Variance=%f, Min=%f, Max=%f\n", gSum/Ntot,(gSum_sq-gSum*gSum/Ntot)/(Ntot-1), gMin, gMax);
        printf("\n Execution time of the program with %d cores is  %f seconds\n", numprocs, end-start);
    }

    MPI_Finalize(); /* Shut down MPI */

    return 0;
}
