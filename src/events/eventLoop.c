#include <SDL.h>
#include "../ui/renderer.h"
#include "keyboardEventHandler.h"
#include "windowEventHandler.h"



static int eventLoopState=1;
static SDL_Event event;


void eventLoop(){

while(eventLoopState){

    while (SDL_PollEvent(&event))
    {
       switch (event.type)
       {
       case SDL_TEXTINPUT:
            // for processing alpha-numeric inputs from the keyboard
            keyBoardInputHandler(event.text.text,0);
        break;

        case SDL_WINDOWEVENT:
            // for processing win size change            
           windowResizeHandler(event.window);
        break;

        case SDL_QUIT:
            printf("%s","\nclosing app\n");
            eventLoopState=0;
        break;
       }
    }
    


}


}