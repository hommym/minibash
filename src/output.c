#include <SDL_ttf.h>
#include <SDL.h>
#include "output.h"


static int x=0;
static int y=0;
static int texW = 0, texH = 0;
static SDL_Color white = {255, 255, 255, 255}; // RGBA
static int winH=0;
static int winW=0;


static void calcCharPosition(){
  //calc new x  and y position for char to be displayed
    if((x+texW)>winW){
    x=0;
    y=y+texH;    
    }else{
    x=x+texW;
    }
}


void renderChar(char *charPointer){
  printf("Text input: %c\n", charPointer[0]);
    // SDL_GetWindowSizeInPixels(windows,&winW,&winH);
    // SDL_Surface *surface = TTF_RenderText_Solid(font, charPointer, white);
    

    // SDL_Texture *texture = SDL_CreateTextureFromSurface(render, surface);
    // SDL_FreeSurface(surface); // we don’t need the surface anymore

    // calcCharPosition();     
    // // Query texture size
    // SDL_QueryTexture(texture, NULL, NULL, &texW, &texH);
    // SDL_Rect dstrect = { x,y, texW, texH };
    // // printf("%d\n",texW);


    // // Clear screen, draw, present
    // // SDL_SetRenderDrawColor(render, 0, 0, 0, 255); // black background
    // // SDL_RenderClear(render);
    // SDL_RenderCopy(render, texture, NULL, &dstrect);
    // SDL_RenderPresent(render);
    
    // SDL_DestroyTexture(texture);
}