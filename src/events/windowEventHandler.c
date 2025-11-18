#include <SDL.h>
#include "windowEventHandler.h"
#include "keyboardEventHandler.h"
#include "../ui/renderer.h"
#include "../ui/cursor.h"


static int isWinPresent=0;
void windowResizeHandler(SDL_WindowEvent winEvent){
  
    switch (winEvent.event)
    {
    case SDL_WINDOWEVENT_RESIZED:
        printf("%s\n","windows size changed");
        break;

    case SDL_WINDOWEVENT_SHOWN:
    if(isWinPresent==0){
        printf("%s\n","windows is shown");
        displayCWD();
        isWinPresent=1;
    }
    break;    
    
    default:
        break;
    }

}