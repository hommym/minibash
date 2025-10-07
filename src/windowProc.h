#include <SDL.h>

#ifndef WINPROC
#define WINPROC

void windowResizeHandler(SDL_WindowEvent winEvent);
extern SDL_Renderer *render;

#endif