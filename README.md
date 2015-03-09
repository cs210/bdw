# bdw
Bavarian Drone Works puts cool things here


# issues and solutions with BMW SDK

Remember to start the BMW simulator first, then the Xcode simulator. 

If you get error: "linker failed with exit code 1: cannot find file /Frameworks/BMWAppKit.framework/BMWAppKit", run: 

sudo cp -r Frameworks /

from the BMW_SDK directory.
