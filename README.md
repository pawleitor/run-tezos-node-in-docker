# Purpose
To provide a quick way to sync and run a Tezos node on any platform using only Docker. Quickly import a full snapshot of Tezos data and run a Tezos node on **Windows**, Mac, Linux hosts using only Docker and Docker Compose.

# Prerequisites
Install Docker Engine and Docker Compose. For Windows and Mac users, simply install [Docker Desktop](https://www.docker.com/products/docker-desktop), which contains all required software.

For convenience, also install [git](https://git-scm.com/downloads) or [GitHub Desktop](https://desktop.github.com/) to clone repo. Alternatively, you can download a repo directly from GitHub by selecting 'Code' button, then 'Download Zip' option. Once saved, unzip to desired location on your machine. 

The repo location on your machine will be used to store Tezos node data, so you'll want to remember this location. Specifically, a subdirectory in the repo named **data** will be created to store node data. If you ever want/need to retrieve a fresh snapshot, simply delete this directory and re-run the startup convenience script.

# Run node
Once above prerequisites have been installed, you can run the node. On first run, full snapshot data will be retrieved and imported to get your node synced as quickly as possible. Edit the mainnet.env file to change provider of snapshot data if desired.

To run the node, use one of the startup scripts. Windows users will run start_mainnet.bat (double click to run). Mac and Linux users will run start_mainnet.sh.

# Files and their use
* start_mainnet.sh/start_mainnet.bat
  * Convenience scripts to run necessary docker-compose command to start the node
  * This script can be re-run anytime to rebuild, get most recent updates to tezos binaries (via Docker Hub image), or simply to restart the node if something fails
* mainnet.env
  * Contains environment variables that get used by docker-compose for the build and that can also be used to supply arguments to the app itself
* node-setup-from-snapshot.docker-compose.yml
  * docker-compose.yml files can be used to manage one or more containers that are intended to work together
  * It can also pass variables to the container that gets built
* node.dockerfile
  * A Dockerfile builds a specific container from a specific image
  * In our case, this file is building upon the base tezos image
* node-setup-from-snapshot.sh
  * The script that docker-compose will run in order to start the node
  * The snapshot import activity is managed in this script
  * Once snapshot has occurred, this script will detect that data is present and will simply run the node
  * The initial snapshot retrieval and import process will take approximately 1-2 hours

# Troubleshooting
If after syncing and running successfully either of the following happens:
* You encounter unexpected errors that don't resolve after restarting the node
* You are unable to connect to peers

Then do the following:
* Delete the **data** directory to start over (new snapshot retrieval and import, new identity generated, new config created)
* Also verify that ports are open on your machine for P2P connection and create firewall rules if needed
* To create these rules on Windows:
  * Navigate to Firewall, Advanced Settings to open Windows Defender Firewall with Advanced Security utility
  * Select Inbound Rules
  * Create new one if needed or modify existing one
  * The inbound rule needs to specify:
    * Profile is Public
    * Program is: C:\program files\docker\docker\resources\com.docker.backend.exe (or wherever docker backend is installed on your machine)
    * Port is 9732 (or the port you specified in mainnet.env for P2P_PORT_HOST)
    * Protocol type is TCP
    * Action is Allow the Connection

# Notes
After cloning or downloading repo, please feel free to edit all files as you see fit to suit your purposes.

For example, you may want to change tezos node configuration. You could do that by:
*  adding necessary commands to node-setup-from-snapshot.sh
*  copying a config.json file into the container via the Dockerfile
*  directly running 'tezos-node config update' command in the tezos node container (which will get created after you run the startup convenience script above)
