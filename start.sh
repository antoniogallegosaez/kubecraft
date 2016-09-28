# Download the version of the docker client that matches the docker daemon present
#gosetup

# Start goproxy
goproxy 1>&2 &

# start Minecraft C++ server
cd /srv/world
../cuberite_server/Cuberite -d

while true; do sleep 10000; done
