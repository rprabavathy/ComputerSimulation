#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include "collision.h"
#include "input.h"

void collision(Cell *node, int localNodesX){
    
    for (int x = 0; x < localNodesX ; ++x){
        for (int y = 0; y < NODES_Y ; ++y){       
            if(node[y + NODES_Y * x].fluid == 1){    
                int occupiedCount = 0;
                int occupiedIndices[NUM_DIRECTIONS];

                // Check how many directions are occupied and store their indices
                for (int i = 0; i < NUM_DIRECTIONS; ++i) {
                    if (node[y + NODES_Y * x].particles[i] == '1') {
                        occupiedIndices[occupiedCount++] = i;
                    }
                }

                switch (occupiedCount) {
                    case 2:
                        if ((occupiedIndices[0] + 3) % NUM_DIRECTIONS == occupiedIndices[1]) {
                            // Back-to-back occupied, rotate by +60 or -60 degree
                            srand ( time(NULL) );
                            int rotation = rand() % 2 == 0 ? 1 : -1;
                            for (int i = 0; i < 2; ++i) {
                                node[y + NODES_Y * x].particles[occupiedIndices[i]] = '0';
                                node[y + NODES_Y * x].particles[(occupiedIndices[i] + rotation + NUM_DIRECTIONS) % NUM_DIRECTIONS] = '1';
                            }
                        }
                        break;

                    case 3:
                        // Check for alternate directions
                        if ((occupiedIndices[0] + 2) % NUM_DIRECTIONS == occupiedIndices[1] &&
                            (occupiedIndices[1] + 2) % NUM_DIRECTIONS == occupiedIndices[2]) {
                            // Rotate by +60 degree or -60 degree
                            srand ( time(NULL) );
                            int rotation = rand() % 2 == 0 ? 1 : -1;
                            for (int i = 0; i < 3; ++i) {
                                node[y + NODES_Y * x].particles[occupiedIndices[i]] = '0';
                                node[y + NODES_Y * x].particles[(occupiedIndices[i] + rotation + NUM_DIRECTIONS) % NUM_DIRECTIONS] = '1';
                            }
                        }
                        else{// Check for three occupied directions with one being back-to-back
                            int spectatorIndex;
                            if ((occupiedIndices[0] + 3) % NUM_DIRECTIONS == occupiedIndices[1]){
                                node[y + NODES_Y * x].particles[occupiedIndices[0]] = '0';
                                node[y + NODES_Y * x].particles[occupiedIndices[1]] = '0';
                                spectatorIndex = occupiedIndices[2];
                            }
                            else if((occupiedIndices[2] + 3) % NUM_DIRECTIONS == occupiedIndices[0]){
                                node[y + NODES_Y * x].particles[occupiedIndices[0]] = '0';
                                node[y + NODES_Y * x].particles[occupiedIndices[2]] = '0';
                                spectatorIndex = occupiedIndices[1];
                            }
                            else if((occupiedIndices[1] + 3) % NUM_DIRECTIONS == occupiedIndices[2]){
                                node[y + NODES_Y * x].particles[occupiedIndices[1]] = '0';
                                node[y + NODES_Y * x].particles[occupiedIndices[2]] = '0';
                                spectatorIndex = occupiedIndices[0];
                            } 
                            else{
                                break;
                            }
                            
                            int unOccupiedPair[2];
                            int indices = 0;

                            for (int i = 0; i < NUM_DIRECTIONS; ++i) {
                                int isOccupied = 0;
                                for (int j = 0; j < 3; j++) {
                                    if (i == occupiedIndices[j]) {
                                        isOccupied = 1;
                                        break;
                                    }
                                }

                                if (!isOccupied && (i != (spectatorIndex + 3) % NUM_DIRECTIONS)) {
                                    unOccupiedPair[indices++] = i;
                                }
                            }
                            
                            node[y + NODES_Y * x].particles[unOccupiedPair[0]] = '1';
                            node[y + NODES_Y * x].particles[unOccupiedPair[1]] = '1';
                            
                            // Keep the spectator direction the same
                            node[y + NODES_Y * x].particles[spectatorIndex] = '1';
                            node[y + NODES_Y * x].particles[(spectatorIndex + 3) % NUM_DIRECTIONS] = '0';
                        }
                        break;
                    case 4:
                        // Check for one back-to-back pair empty
                        if ((occupiedIndices[0] + 3) % NUM_DIRECTIONS == occupiedIndices[2] &&
                            (occupiedIndices[1] + 3) % NUM_DIRECTIONS == occupiedIndices[3]) {
                            // Rotate by +60 degree or -60 degree
                            srand ( time(NULL) );
                            int rotation = rand() % 2 == 0 ? 1 : -1;
                            int tmp[4];
                            for (int i = 0; i < 4; ++i) {
                                node[y + NODES_Y * x].particles[occupiedIndices[i]] = '0';
                                tmp[i]=(occupiedIndices[i] + rotation + NUM_DIRECTIONS) % NUM_DIRECTIONS;
                            }
                            for (int i = 0; i < 4; ++i) {
                                node[y + NODES_Y * x].particles[tmp[i]] = '1';
                            }
                        }
                        break;

                    default:
                        break;
                }
                node[y + NODES_Y * x].value = binaryToDecimal(node[y + NODES_Y * x].particles);
            }
        }
    }

}



