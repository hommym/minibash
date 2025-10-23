#!/bin/bash



#cd into src
cd src/events

# compile all c file in src to objcet files in build

for file in $(ls *.c)
do
        if [ $file == "eventLoop.c" ]; then 
            gcc -c $file -o ../../build/eventLoop.o $(pkg-config --cflags sdl2) 

        elif [ $file == "keyboardEventHandler.c" ]; then 
              gcc -c $file -o ../../build/keyboardEventHandler.o $(pkg-config --cflags sdl2) -lSDL2_ttf    
        elif [ $file == "windowEventHandler.c" ]; then 
              gcc -c $file -o ../../build/windowEventHandler.o $(pkg-config --cflags sdl2) -lSDL2_ttf         
        fi

done


#going back to src
cd ..

cd ui

for file in $(ls *.c)
do
      if [ $file == "renderer.c" ]; then 
                  gcc -c $file -o ../../build/renderer.o $(pkg-config --cflags sdl2) -lSDL2_ttf 

      elif [ $file == "cursor.c" ]; then 
            gcc -c $file -o ../../build/cursor.o $(pkg-config --cflags sdl2) -lSDL2_ttf 

      fi

done



# going back root dir 
cd ../.. 

#cd into utils
cd utils

#compile all asm files in this dir(N/A)



# going back root dir 
cd .. 

#compiling the asm entry point minibash.asm
yasm -f elf64 -g dwarf2 -l build/main.lst -o build/minibash.o minibash.asm 


#cd into build dirr for linking
cd build

#link everything into a single exe
gcc minibash.o eventLoop.o renderer.o keyboardEventHandler.o windowEventHandler.o cursor.o -no-pie -o minibash $(sdl2-config --libs) $(pkg-config --libs SDL2_ttf)     


# going back root dir 
cd .. 