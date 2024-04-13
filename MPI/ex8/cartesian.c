/* Exercise 8 : Cartesian Communicators
 *  Prabavathy Rajasekaran (2130757)
 */
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <mpi.h>
# define mRows 4    // No of rows of Process Grid
# define nCols 12   // No of columns of Process Grid
# define NShifts 1000   // Total no of shifts to be applied to regain the Image

int prod(int *vec, int dim){
    int i;
    int val = 1;
    for (i = 0; i < dim; i++)
        val *= vec[i];
    return (val);
}

int main(int argc, char *argv[]){
    int nprocs;
    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &nprocs);
    
    // parameters for Cartesian communication grid
    int ndims = 2;
    int dims[2] = {mRows, nCols};
    int periods[2] = {1, 1}; // Torus wrapping either-wise Row & Column
    int cart_rank;
    int coords[ndims];
    MPI_Comm cart_comm; // Cartesian New Communicator

    if (nprocs != prod(dims, ndims))
        MPI_Abort(MPI_COMM_WORLD, -1);

    // Create communicator of process grid 4* 12 with Cartesian topology 
    MPI_Cart_create(MPI_COMM_WORLD, ndims, dims, periods, 1, &cart_comm);
    MPI_Comm_rank(cart_comm, &cart_rank);// Get rank with respect to new communicator
    MPI_Cart_coords(cart_comm, cart_rank, 2, coords); // get coordinates of processor Rank

    //Start :: Reading Image Matrix and distribute it as chunks of size m_bar*n_bar among Processors
    FILE* imageMatrix; // Read the puzzled Image Matrix as A
    int m,n; // Size of Image Matrix(m*n)
    if(cart_rank == 0){
        imageMatrix = fopen("/work/korzec/LAB2/ex8/notstirred.txt", "r");
        fscanf(imageMatrix, "%d", &m); 
        fscanf(imageMatrix, "%d", &n);
    }
        
    // Broadcast sizes of matrices from rank 0 across Cartesians Communicator
    MPI_Bcast(&m, 1, MPI_INT, 0, cart_comm);
    MPI_Bcast(&n, 1, MPI_INT, 0, cart_comm);
    
    int q = nCols; //no of grid elements across rows to be divided among Processes as checker Board
    MPI_Bcast(&q, 1, MPI_INT, 0, cart_comm);
    
    int m_bar = m / mRows; // local block matrix row size as m_bar
    MPI_Bcast(&m_bar, 1, MPI_INT, 0, cart_comm);

    int n_bar = n / nCols; // local block matrix column size as n_bar
    MPI_Bcast(&n_bar, 1, MPI_INT, 0, cart_comm);


    double* local_A = malloc(m_bar * n_bar * sizeof(double));
    double * local_tmp_A = malloc(m_bar*n_bar*sizeof(double));
        
    if (cart_rank == 0){
        int coordinates[2],dest;
        for (int i = 0; i < m; i++){
            coordinates[0] = i/m_bar;
            for(int gc = 0; gc < q; gc++){
                coordinates[1] = gc;
                MPI_Cart_rank(cart_comm, coordinates, &dest);
                if(dest == 0){
                    for(int j = 0; j < n_bar; j++){
                        fscanf(imageMatrix,"%lf",&local_A[i*n_bar + j]);
                    }
                }else{
                    for(int j = 0; j < n_bar; j++){
                        fscanf(imageMatrix,"%lf",&local_tmp_A[j]);
                    }
                    MPI_Send(local_tmp_A,n_bar,MPI_DOUBLE,dest,dest,cart_comm);
                }
            } 
        }
        free(local_tmp_A);
        fclose(imageMatrix);
    }
        
    if(cart_rank>0){
        for(int j = 0; j < m_bar; j++){
            MPI_Recv(&local_A[j*n_bar], n_bar, MPI_DOUBLE, 0, cart_rank, cart_comm, MPI_STATUS_IGNORE);
        }
    }
    //End :: Reading Image Matrix
  
    //Start :: Read the Operations to be applied on target rows and columns from shifts.dat file
    int shifts[NShifts][2];

    if (cart_rank == 0){
        FILE *shiftsFile = fopen("/work/korzec/LAB2/ex8/shifts.dat", "r");
        if (shiftsFile == NULL){
            perror("Error opening shifts file");
            MPI_Abort(cart_comm, -1);
        }
        for (int i = 0; i < NShifts; i++){
            fscanf(shiftsFile, "%d %d", &shifts[i][0], &shifts[i][1]);
        }
        fclose(shiftsFile);
    }

    MPI_Bcast(shifts, NShifts * 2, MPI_INT, 0, cart_comm);
    
    //End :: Reading shifts.dat file

   /* Algorithm to rearrange the Image Puzzle by applying the operation on the 
    * targeted Columns and rows
    * If J = 0  or 1, we need to circularly shift the local matrix along the 
    * targeted columns (k) downwards or upwards
    * If J = 2 or 3 , we need to circularly shift the local matrix along the 
    * targeted rows rightwards or backwards
    */ 
    for (int i = 0; i < NShifts; i++){   
       
        int j = shifts[i][0]; // operation to be applied
        int k = shifts[i][1]; // targeted column or rows
        int srcNeighborRank, destNeighborRank;
        // Column Wise Operation where column rank is same and row rank differs    
        if ((j == 0 || j == 1) && (coords[1] == k)){ 
            //finding top and bottom neighbors Rank in targeted column(k) 
            MPI_Cart_shift(cart_comm, 0, (j == 0) ? 1 : -1, &srcNeighborRank, &destNeighborRank);
            //Apply circular shift on local_A downwards(j=0) or upwards(j=1)
            MPI_Sendrecv_replace(local_A, m_bar*n_bar, MPI_DOUBLE,destNeighborRank,0,srcNeighborRank,0,cart_comm,MPI_STATUS_IGNORE);
        }
        //Row Wise Operation where row rank is same and column rank differs
        else if ((j == 2 || j == 3) && (coords[0] == k)){ 
            //finding left and right neighbors Rank in targeted row(k)
            MPI_Cart_shift(cart_comm, 1, (j == 2) ? 1 : -1, &srcNeighborRank, &destNeighborRank);
            //Apply circular shift on local_A rightwards(j=2) or leftwards(j=3)
            MPI_Sendrecv_replace(local_A, m_bar*n_bar, MPI_DOUBLE,destNeighborRank,0,srcNeighborRank,0,cart_comm,MPI_STATUS_IGNORE);
        }
    }

    MPI_Barrier(cart_comm);

   // Start :: Write the output Image(rearranged Image) back into the C.txt file
    if (cart_rank == 0) {
        FILE *outImage = fopen("C.txt", "w");
        if (outImage == NULL) {
            perror("Error opening file");
            exit(EXIT_FAILURE);
        }

        fprintf(outImage, "%d\n%d\n", m, n);
        double* temp = malloc(n_bar*sizeof(double));
        int coordinates[2];
        int  source;
        for (int i = 0; i < m; i++){
             coordinates[0] = i/m_bar;
            for(int gc = 0; gc < q; gc++){
                coordinates[1] = gc;
                MPI_Cart_rank(cart_comm, coordinates, &source);
                if(source == 0){
                    for(int j = 0; j < n_bar; j++){
                        fprintf(outImage,"%lf\n",local_A[i*n_bar + j]);
                    }
                }else{
                    MPI_Recv(temp,n_bar,MPI_DOUBLE,source,source,cart_comm,MPI_STATUS_IGNORE);
                    for(int j = 0; j < n_bar; j++){
                        fprintf(outImage,"%lf\n",temp[j]);
                    }
                } 
            }
        }
        free(temp);
        fclose(outImage);
    }

    if(cart_rank>0){
        for(int j = 0; j < m_bar; j++){
            MPI_Send(&local_A[j*n_bar], n_bar, MPI_DOUBLE, 0, cart_rank, cart_comm);
        }    
    }
    //End :: Write the output Image
    MPI_Finalize();
}
