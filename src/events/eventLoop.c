#include "eventLoop.h"



// eventLoopState=1;
static SDL_Event event;


void eventLoop(){
pthread_t tid;
pthread_attr_t attr;
pthread_attr_init(&attr);
pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
int isTCreated =pthread_create(&tid,NULL,outputProcess,NULL);
if(isTCreated!=0){
printf("%s\n","An error occured during thread creation");
fprintf(stderr, "pthread_create: %s\n", strerror(isTCreated));
}

while(eventLoopState){

    while (SDL_PollEvent(&event))
    {
       switch (event.type)
       {
       case SDL_TEXTINPUT:
            // for processing alpha-numeric inputs from the keyboard
            keyBoardInputHandler(event.text.text,0,NULL);
        break;

        case SDL_WINDOWEVENT:
            // for processing win size change            
           windowResizeHandler(event.window);
        break;
        case SDL_KEYDOWN:
            // for processing escp chars             
           keyBoardInputHandler(NULL,1,&(event.key.keysym));
           break;    
        case SDL_QUIT:
            printf("%s","\nclosing app\n");
            eventLoopState=0;
            pthread_attr_destroy(&attr);
            break;
       }
    }
    


}

}