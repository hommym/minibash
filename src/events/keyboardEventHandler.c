#include "../ui/renderer.h"
#include "keyboardEventHandler.h"




int stP=0;
char userInputs[1000];

void keyBoardInputHandler(char *addressOfData,int ecsFlag){

    //check if char is an escape char or alpha-numeric
    
    if(ecsFlag){
        // have not imp
    }
    else{
        userInputs[stP]=addressOfData[0];
        renderChar(userInputs+stP);
        ++stP;       
    }


}
