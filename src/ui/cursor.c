#include <SDL.h>
#include "renderer.h"



// create rec to rep the cursor

// x position of cursor
static int xPos=0;


// y position of cursor
static int yPos=0;



static SDL_Rect cursor={0,0,7,25};



void displayCursor(){
    SDL_SetRenderDrawColor(render,255,255,255,255);
    SDL_RenderFillRect(render,&cursor);
    SDL_RenderPresent(render);
}


int getCursorXPos(){
    return xPos;
}

int getCursorYPos(){
    return yPos;
}

void changeCursorXPos(int pos){
    xPos=pos;
}

void changeCursorYPos(int pos){
    yPos=pos;
}

