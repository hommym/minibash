#include "output.h"
#include "charProc.h"



static char userInputs[1000];
static int stP=0;


void charProcessor(char *addressOfData,int ecsFlag){

    //check if char is an escape char or alpha-numeric
    
    if(ecsFlag){
        // have not imp
    }
    else{
        userInputs[stP]=addressOfData[0];
        showChar(userInputs+stP);
        ++stP;       
    }


}