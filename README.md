# Kubecraft

A simple Minecraft client, to visualize and manage Kubernetes pods in Openshift.
See the original readme for details on upstream.

## How to run Kubecraft

1. **Install Minecraft Client: [minecraft.net](https://minecraft.net)**

	The Minecraft client hasn't been modified, just get the official release.
	You will need to have a minecraft login/user.
	For linux, get the Minecraft.jar and run:

	```
    java -Xmx1024M -Xms512M -jar /home/user/.minecraft/Minecraft.jar &
	```

	![alt text](https://github.com/eformat/kubecraft/raw/master/docs/img/minecraft-client.png "Minecraft Client")

2. **Running on Openshift**

	Build kubecraft image

	Setup your environment (you need golang)
	```
	git clone git@github.com:eformat/kubecraft.git
    cd ~/git/kubecraft/go/src/kubeproxy
    export GOPATH=/home/user/go
    go get ./...
	```
	Create the docker image
	```
    make
    docker build -t eformat/kubecraft .
	```	
    Create a new Openshift project and push the docker image
	```
	oc new-project kubecraft --display-name='Kubecraft' --description='Kubernetes Minecraft'
	docker login -u user -e user@domain -p `oc whoami -t` docker-registry.apps.domain
	docker tag eformat/kubecraft docker-registry.apps.domain/kubecraft/kubecraft:latest
	docker push docker-registry.apps.domain/kubecraft/kubecraft:latest
	```
	Create the application (Cuberite runs as root for now)
	```
	oc new-app kubecraft/kubecraft
	oc adm policy add-cluster-role-to-user cluster-reader system:serviceaccount:kubecraft:default
	oc adm policy add-scc-to-user anyuid -z default -n kubecraft
	```
	Set environment variables for the Namespace we are managing (with kubecraft) and our authentication location for oc command
	```
	oc set env dc kubecraft NAMESPACE=minecraft
	oc set env dc kubecraft KUBECONFIG=/etc/kubeconfig/config
	```
	Create a configmap with our credentials (for now)
	```
	oc create configmap kubecraft-config --from-file=/home/user/.kube/config
	oc volume dc/kubecraft --add --overwrite -t configmap --configmap-name=kubecraft-config --name=kubecraft-config-volume-1 -m=/etc/kubeconfig
	```
	Port Forward local connection for miecraft client (could use SNI)
	```
	oc port-forward kubecraft-16-q8fs9 25565:25565
	```
	Create a server in Minecraft and connect to
	```
	localhost:25565
	```
	
	![alt text](https://github.com/eformat/kubecraft/raw/master/docs/img/kubecraft.png "Kubecraft Client")