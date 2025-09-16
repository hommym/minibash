#include <SDL_ttf.h>
#include <SDL.h>
#include "output.h"


static int x=0;
static int y=0;
static char charStorage[1000];
static int stP=0;

void showChar(char *addressOfData){
    charStorage[stP]=addressOfData[0];
    ++stP;

    SDL_Color white = {255, 255, 255, 255}; // RGBA
    SDL_Surface *surface = TTF_RenderText_Solid(font, charStorage, white);

    SDL_Texture *texture = SDL_CreateTextureFromSurface(render, surface);
    SDL_FreeSurface(surface); // we don’t need the surface anymore


    // Query texture size
    int texW = 0, texH = 0;
    SDL_QueryTexture(texture, NULL, NULL, &texW, &texH);
    SDL_Rect dstrect = { x,y, texW, texH };


    // Clear screen, draw, present
    // SDL_SetRenderDrawColor(render, 0, 0, 0, 255); // black background
    SDL_RenderClear(render);
    SDL_RenderCopy(render, texture, NULL, &dstrect);
    SDL_RenderPresent(render);
    
    SDL_DestroyTexture(texture);
}