#include <SDL.h>
#include "windowEventHandler.h"
#include "keyboardEventHandler.h"
#include "../ui/renderer.h"


void windowResizeHandler(SDL_WindowEvent winEvent){
  
    switch (winEvent.event)
    {
    case SDL_WINDOWEVENT_RESIZED:
        printf("%s\n","windows size changed");
        break;
    
    default:
        break;
    }

}