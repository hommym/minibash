#include <SDL.h>

#ifndef TextEventHandler
#define TextEventHandler


void keyBoardInputHandler(char *addressOfData,int ecsFlag,SDL_Keysym *key);
void updateScreen();
void displayCWD();
extern char* getCwd();
extern char currentUserInput[1000];

typedef struct PrintableChar{
SDL_Rect rect;
SDL_Texture *texture;
}PrintableChar;

#endif