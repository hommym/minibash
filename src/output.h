#include <SDL.h>
#include <SDL_ttf.h>

#ifndef Output_H
#define Output_H

extern SDL_Renderer *render;
extern TTF_Font *font;
void showChar(char *addressOfData);

#endif