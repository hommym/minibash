#include <SDL.h>
#include "output.h"
#include "charProc.h"

static int eventLoopState=1;
static SDL_Event event;


void eventLoop(){

while(eventLoopState){

    while (SDL_PollEvent(&event))
    {
       switch (event.type)
       {
       case SDL_TEXTINPUT:
            // printf("Text input: %s\n", event.text.text);
            // for processing alpha-numeric inputs from the keyboard
            charProcessor(event.text.text,0);
        break;

        case SDL_QUIT:
            printf("%s","\nclosing app\n");
            eventLoopState=0;
        break;
       }
    }
    


}


}