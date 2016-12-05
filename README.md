# predixmachine-starter bundles
##This repository holds the various machine starter bundles.

Each starter bundle has quickstart.sh script that sets up Predix services in the cloud, builds the bundle and injects it into the pre-configured Predix Machine tar ball so that you can quickly get started sending data from Predix Machine to the cloud and visualize the data in a UI.

Follow the tutorials for [Edge Starters](http://predix.io/resources/tutorials).  
  - Scroll down, look for Edge Starters and choose the device you are interested in.

##Customize a predix-machine-template-adapter 

If you don't see an Edge Starter for a board you are interested in you can easily create one by following the example in the repo [predix-machine-template-adapter](https://github.com/PredixDev/predix-machine-template-adapter.git).

1. git clone https://github.com/PredixDev/predix-machine-template-adapter.git
2. In the template project, review the **quickstart.sh** script.  Notice the call to the  [predix-scripts](https://github.com/PredixDev/predix-scripts.git)/quickstart.sh script that handles much of the heavy lifting for you.
  - quickstart.sh -smf
    - Logs in to your Predix Cloud space 
    - Creates a UAA and a client-id and a user
    - Creates a Time Series instance and add authorities to the client-id
    - Creates a Predix Asset instance and add authorities to the client-id
    - Creates a simple UI NodeJS app to view the data
    - Downloads a Predix Machine
  - ***apply the device specific changes*** - this is where you can customize the quickstart script to your devices needs
    - SampleDataNode.java - You can configure the device apis to connect to sensors
    - SampleMachineAdapter.java - You have to implement the readData method to read data from the sensor using your device api
  - quickstart.sh -t
    - Tar (zip) up the Predix Machine with the device specific behavior
    - Copies the tar to the device
3. Review the contents of the config folder.  This is where important property files for Predix Machine are located and your script can replace those files in the downloaded Predix Machine.
4. Review and **change the MachineAdapter.java** file to retrieve data from the Device APIs and forward that data to the Spillway.
5. Contribute the Starter back to us and we can share it in the community
  - Post a github Issue here and we'll take a look!

## Device specific template repos
1. Adapter Framework        - https://github.com/PredixDev/predix-machine-template-adapter
2. Adapter for Edison       - https://github.com/PredixDev/predix-machine-template-adapter-edison
3. Adapter for Raspberry Pi - https://github.com/PredixDev/predix-machine-template-adapter-pi

[![Analytics](https://ga-beacon.appspot.com/UA-82773213-1/predix-machine-templates/readme?pixel)](https://github.com/PredixDev)
