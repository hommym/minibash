#include <SDL.h>

#ifndef WindowEventHandler
#define WindowEventHandler

void windowResizeHandler(SDL_WindowEvent winEvent);
extern SDL_Renderer *render;

#endif