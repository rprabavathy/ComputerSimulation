#include "input.h"  /* Include the header (not strictly necessary here) */
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <string.h>

// Directions for hexagonal lattice
const int evenDirections[NUM_DIRECTIONS][2] = {{0,1}, {1,0}, {1,-1}, {0,-1}, {-1,-1}, {-1,0}};
const int oddDirections[NUM_DIRECTIONS][2] = {{0,1}, {1,1}, {1,0}, {0,-1}, {-1,0}, {-1,1}};
const double unitVectors[NUM_DIRECTIONS][2] = {{-1.0,0.0},{-0.5,sqrt(3)/2}, {0.5,sqrt(3)/2}, {1.0,0.0}, {0.5,-sqrt(3)/2}, {-0.5,-sqrt(3)/2}};

const int Dir_BC[] = {8,4,2,0};

int getIndex(int x, int y, int localNodesY) {
    return x * localNodesY + y;
}

int binaryToDecimal(char *binaryNum) {
    int decimalNum = 0;
    int base = 1;
    int i = 5;

    while (binaryNum[i] != '\0') {
        if (binaryNum[i] == '1') {
            decimalNum += base;
        }
        base *= 2;
        i--;
    }
    return decimalNum;
}

void binaryForm(int number, char* binary) {
    if(number != OBSTACLE_NUMBER){
    for (int i = 5; i >= 0; --i) {
        binary[5-i] = '0' + ((number >> i) & 1);
    }
    binary[6] = '\0';
    }
}

// Function to check if a number is even
int isEven(int number) {
    return number % 2 == 0;
}

const int randomDirichletBoundary(const int BC_Dir[], int size){
    return BC_Dir[rand() % size];
}


//Mass = sum of all elementary particles of a node with state 0 or 1
                                                                                                                           
int calcMass(char* legs){
    int mass = 0;
    for (int i = 5; i >= 0; --i) {
        if (legs[i] == '1') {
           mass++;
        }
    }
    return mass;
}

double* calcVelocity(char* legs, double velocity[2]){
    velocity[0] = 0;
    velocity[1] = 0;
    for (int i = 0; i < NUM_DIRECTIONS; ++i) {
        if(legs[i] == '1') {
            velocity[0] += 1.0*unitVectors[i][0];
            velocity[1] += 1.0*unitVectors[i][1];
        }
    }
}

void initializeGrid(Cell *cellNode, int localNodesX, int rank) {
    srand(time(NULL));
    for (int x = 0; x < localNodesX; ++x) {
        for (int y = 0; y < NODES_Y; ++y) { 
            int globalX = rank * localNodesX + x;
            cellNode[y + NODES_Y*x].index = getIndex(globalX, y, NODES_Y);
            if(y == 0  && globalX != 0 ){ 
                cellNode[y + NODES_Y*x].fluid = 2;
				for(int k = 0; k < NUM_DIRECTIONS; ++k){
                    double randValue = (double)rand() / (RAND_MAX + 1.0);
                    cellNode[y + NODES_Y*x].particles[k] = randValue > 0.91 ? '1' : '0';
                }
				cellNode[y + NODES_Y*x].value = binaryToDecimal(cellNode[y + NODES_Y*x].particles);
                //cellNode[y + NODES_Y*x].value = randomDirichletBoundary(Dir_BC, 4);
                //binaryForm(cellNode[y + NODES_Y*x].value, cellNode[y + NODES_Y*x].particles);
            }else if(y == NODES_Y-1 && globalX != NODES_X-1){ 
                cellNode[y + NODES_Y*x].fluid = 2;
                //cellNode[y + NODES_Y*x].value = randomDirichletBoundary(Dir_BC, 4);
                binaryForm(cellNode[y + NODES_Y*x].value, cellNode[y + NODES_Y*x].particles);
            }else if(pow((globalX - OBS_X),2) + pow((y - OBS_Y),2) <= pow((RADIUS/LATTICE_SPACING),2)){
                cellNode[y + NODES_Y * x].value = OBSTACLE_NUMBER;
                cellNode[y + NODES_Y * x].fluid = 0;
                binaryForm(cellNode[y + NODES_Y*x].value, cellNode[y + NODES_Y*x].particles);
            }else{
                if( globalX == 0 || globalX == NODES_X-1){
                    cellNode[y + NODES_Y*x].fluid = 3; // Slip Boundary
                }else{
                    cellNode[y + NODES_Y*x].fluid = 1;
                }
                
                /* for(int k = 0; k < NUM_DIRECTIONS; ++k){
                    double randValue = (double)rand() / (RAND_MAX + 1.0);
                    cellNode[y + NODES_Y*x].particles[k] = randValue > 0.91 ? '1' : '0';
                } */
				binaryForm(cellNode[y + NODES_Y*x].value, cellNode[y + NODES_Y*x].particles);
                //cellNode[y + NODES_Y*x].value = rand() % NUM_STATES;
                //cellNode[y + NODES_Y*x].value = binaryToDecimal(cellNode[y + NODES_Y*x].particles);
           }
        }
    }    
}

void updateNodewithMassAndVelocity(Cell *cellNode, int localNodesX){
	
	 for (int x = 0; x < localNodesX-1 ; ++x) {
        for (int y = 0; y < NODES_Y; ++y) {
            // Updating the Dirichlet with different flow after each time step of collision & Streaming
            if(cellNode[y + NODES_Y * x].fluid == 2){
                cellNode[y + NODES_Y*x].value = randomDirichletBoundary(Dir_BC, 4);
            //	cellNode[y+NODES_Y*x].value = 4;
				binaryForm(cellNode[y + NODES_Y*x].value, cellNode[y + NODES_Y*x].particles);
				cellNode[y + NODES_Y*x].mass = calcMass(cellNode[y + NODES_Y*x].particles);
                calcVelocity(cellNode[y + NODES_Y*x].particles, cellNode[y + NODES_Y*x].velocity);
            }
            if(cellNode[y + NODES_Y * x].fluid == 1){
                cellNode[y + NODES_Y * x].value = binaryToDecimal(cellNode[y + NODES_Y * x].particles); 
                cellNode[y + NODES_Y*x].mass = calcMass(cellNode[y + NODES_Y*x].particles);
                calcVelocity(cellNode[y + NODES_Y*x].particles, cellNode[y + NODES_Y*x].velocity);
            }if(cellNode[y + NODES_Y * x].fluid == 0){
                cellNode[y + NODES_Y*x].value = OBSTACLE_NUMBER;
                binaryForm(cellNode[y + NODES_Y*x].value, cellNode[y + NODES_Y*x].particles);
                cellNode[y + NODES_Y*x].mass = calcMass(cellNode[y + NODES_Y*x].particles);
                calcVelocity(cellNode[y + NODES_Y*x].particles, cellNode[y + NODES_Y*x].velocity);
            }
        }
    }
}
