# bdw
Bavarian Drone Works puts cool things here

# Getting the correct frameworks to run an app with BMW

1. Open up the droneControl project in xCode. 
2. Open up the BMW_SDK/Examples/HMIFeatureTour project in xCode. 
3. Drag everything in the HMIFeatureTour Frameworks group into droneControl's frameworks group.  
4. These changes will not be reflected on github due to gitignore.


# issues and solutions with BMW SDK

Remember to start the BMW simulator first, then the Xcode simulator. 

If you get error: "linker failed with exit code 1: cannot find file /Frameworks/BMWAppKit.framework/BMWAppKit", run: 

sudo cp -r Frameworks /

from the BMW_SDK directory.
