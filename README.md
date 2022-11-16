# Platformio Docker Builder

## Why?

Wasn't overly happy with the platformio containers available on the hub and there were a couple of things I wanted to make work:

 * Globally installed platformio executable
 * Ability to run as any user
 * Automated build as much as humanly possible in many environments
 * Have assets generated during the build mappable to directories and maintain the user ID
 * Each platformio project ends up with its own .platformio and .pio directories (nice isolation)

None of the existing containers did all of the above so I build my own and pushed a tag for all versions of platofmio. There should
be a tag for all versions of platformio available and the "latest" tag will always be the latest version available the last time
the build was run

## How...

This is how I run it - 
```
docker run -e HOME=`pwd` -u $UID -w `pwd` -v `pwd`:`pwd` --rm -it takigama/platformio platformio run
```

What it does:

 * Sets the home directory inside the container to the current directory (usually the where platformio.ini is)
 * Maps pwd to pwd inside the container
 * Sets the working directory to `pwd` (the directory where the command is executed)
 * removes the container after the build.

Obviously you can change the command on the end "platformio run" to anything you like, but the end result is that
the .platformio directory (where it stores all the binaries and such for building the device) are inside your current
directory as well as the .pio directory (where it stores the compiled firmware). The point being that it keeps alot of
the downloaded components of the build context and makes re-usability quite decent for any given project while also 
maintaining complete isolation between projects. 


If you're feeling brave you can try and navigate the pain of pushing a firmware from docker direct to a device:

```
docker run --device=/dev/ttyACM0 -e HOME=`pwd` -u 1000 -w `pwd` -v `pwd`:`pwd` --rm -it takigama/platformio platformio run -t upload
```

But it can be a bit painful and there are many things that can get in the way (user inside docker not having permissions to the
device for eg, and dockers support for such devices can be a bit average)
