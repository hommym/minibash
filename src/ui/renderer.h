#include <SDL.h>
#include <SDL_ttf.h>
#include "../events/keyboardEventHandler.h"

#ifndef Renderer
#define Renderer

extern SDL_Renderer *render;
extern TTF_Font *font;
extern SDL_Window *windows;
void renderChar(PrintableChar *allData,int noItems);


#endif