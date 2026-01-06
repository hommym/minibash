#include <SDL.h>
#include <pthread.h>

#ifndef EVENTLOOP
#define EVENTLOOP


int eventLoopState=1;
void eventLoop();
extern void *outputProcess(void *args);
extern void keyBoardInputHandler(char *addressOfData,int ecsFlag,SDL_Keysym *key);
extern void windowResizeHandler(SDL_WindowEvent winEvent);

#endif