#ifndef INPUT_H_ 
#define INPUT_H_

#define SIZE_X 15 // rows
#define SIZE_Y 60  // columns
#define LATTICE_SPACING 0.1
#define RADIUS 2
#define OBSTACLE_NUMBER 64
#define OBS_X 75 
#define OBS_Y  150
#define NODES_X ( (int) (SIZE_X / LATTICE_SPACING))
#define NODES_Y ( (int) (SIZE_Y / LATTICE_SPACING))
#define NUM_STATES 64
#define NUM_DIRECTIONS 6
#define NSTEPS 10000
#define NPRODUCTION 100

// Directions for hexagonal lattice
extern const int oddDirections[NUM_DIRECTIONS][2];
extern const int evenDirections[NUM_DIRECTIONS][2];
extern const double unitVectors[NUM_DIRECTIONS][2];

extern const int Dir_BC[];

typedef struct {
    int index;
    int value;
    int fluid;
    int mass;
    double velocity[2];
    char particles[NUM_DIRECTIONS];
} Cell;

int getIndex(int x, int y, int localNodesY);
int binaryToDecimal(char *binaryNum);
void binaryForm(int number, char* binary);
int isEven(int number);
void initializeGrid(Cell *cellNode, int localNodesX, int rank);
const int randomDirichletBoundary(const int BC_Dir[], int size);
int calcMass(char* legs);
double* calcVelocity(char* legs, double* velocity);
void updateNodewithMassAndVelocity(Cell *cellNode, int localNodesX);

#endif 
