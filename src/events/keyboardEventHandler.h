#include <SDL.h>

#ifndef TextEventHandler
#define TextEventHandler


void keyBoardInputHandler(char *addressOfData,int ecsFlag,SDL_Keysym *key);
void updateScreen();
void displayCWD();
void *outputProcess(void *args);
extern char *getCwd();
extern int readSysCall(int fd,char *data);
extern int writeSysCall(int fd,char *data);
extern char currentUserInput[1000];
extern int masterFd;
extern int slaveFd;
extern int eventLoopState;

typedef struct PrintableChar{
SDL_Rect rect;
SDL_Texture *texture;
}PrintableChar;

#endif