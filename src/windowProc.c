#include <SDL.h>
#include "windowProc.h"
#include "charProc.h"
#include "output.h"


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