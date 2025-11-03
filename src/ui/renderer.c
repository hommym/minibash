#include <SDL_ttf.h>
#include <SDL.h>
#include "renderer.h"












void renderChar(PrintableChar data){
SDL_SetRenderDrawColor(render, 0, 0, 0,255); // black background
SDL_RenderClear(render);
SDL_RenderCopy(render, data.texture, NULL, &data.rect);
SDL_RenderPresent(render);  
}