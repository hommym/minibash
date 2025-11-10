#include <SDL.h>
#include "renderer.h"



// create rec to rep the cursor

// x position of cursor
static int xPos=0;


// y position of cursor
static int yPos=0;



static SDL_Rect cursor={0,0,7,20};



void displayCursor(){
cursor.x=xPos;
cursor.y=yPos;    
SDL_SetRenderDrawColor(render,255,255,255,0);
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

