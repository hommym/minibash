#include <SDL.h>

#ifndef TextEventHandler
#define TextEventHandler

extern char userInputs[1000];
extern int stP;
void keyBoardInputHandler(char *addressOfData,int ecsFlag);


typedef struct PrintableChar{
SDL_Rect rect;
SDL_Texture *texture;
}PrintableChar;

#endif