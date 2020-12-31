# esp-idf-image
Docker image for esp-idf toolchain

## Features
This project allows you to 
- Build esp toolchain inside container
- Run in-container build of your esp project
- Port build enviroment to whatever platorm you like (i.e. cloud)
- Keep your linux environment clean from esp tools, compilers etc.
- Currently v3.3.3 of toolchain is supported

## Usage
In order to prepare you need to execute `make`. This will start your image
preparation. This will get all sources from internet and build toolchain and
download matching esp-idf and all necessery tools. Image build takes a while. 

After image build is done move example script `esp-idf-make` to your esp project
home directory. 

Invoke build by calling `./esp-idf-make`. Other compilation targets works as
well i.e `./esp-idf-make -j3 flash monitor`.

## Other considerations
In order to enable incremental builds `./esp-idf-make` will start esp-idf
container in background. This container is specified to work with dedicated
project only. In order change a project you need to manualy stop container and
remove it . (e.g `docker kill esp-idf`, `docker container rm ...`)
