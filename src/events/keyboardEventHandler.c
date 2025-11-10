#include "../ui/renderer.h"
#include "keyboardEventHandler.h"
#include "../ui/cursor.h"




static PrintableChar inputs[100000]={};
static int pcTracker=0;
static SDL_Color white = {255, 255, 255, 0};


void updateScreen(){
renderChar(inputs,pcTracker);
displayCursor();
}

static void charProcessor(char data){
PrintableChar printable={};
SDL_Surface *surface = TTF_RenderText_Solid(font, &data, white);

SDL_Texture *texture = SDL_CreateTextureFromSurface(render, surface);
SDL_FreeSurface(surface); // we don’t need the surface anymore
printable.texture=texture;

int printableW=0;
int printableH=0;
int winW=0;
int winH=0;
SDL_QueryTexture(texture, NULL, NULL, &printableW, &printableH);
printable.rect = (SDL_Rect){getCursorXPos(),getCursorYPos(),printableW,printableH};
int nextXCusorPos=getCursorXPos()+printableW;

SDL_GetWindowSizeInPixels(windows,&winW,&winH);
if(nextXCusorPos>=winW){
changeCursorXPos(0);
changeCursorYPos(getCursorYPos()+printableH);
}
else changeCursorXPos(nextXCusorPos);

// display character on screen
inputs[pcTracker]=printable;
updateScreen();
pcTracker++;
}


void keyBoardInputHandler(char *addressOfData,int ecsFlag){

    //check if char is an escape char or alpha-numeric
    
    if(ecsFlag){
        // have not imp
    }
    else{
       charProcessor(addressOfData[0]);      
    }


}
