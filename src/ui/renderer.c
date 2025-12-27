#include <SDL_ttf.h>
#include <SDL.h>
#include "renderer.h"







void renderChar(PrintableChar *allData,int noItems){
SDL_SetRenderDrawColor(render, 0, 0, 0,0); // black background
SDL_RenderClear(render);
for(int i=0;i<noItems;i++){
SDL_RenderCopy(render, (allData[i]).texture, NULL, &((allData[i]).rect));
}

}