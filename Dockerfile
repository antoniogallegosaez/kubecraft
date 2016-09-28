FROM golang:1.6.3

RUN wget https://github.com/openshift/origin/releases/download/v1.3.0/openshift-origin-client-tools-v1.3.0-3ab7af3d097b57f933eccef684a714f2368804e7-linux-64bit.tar.gz
RUN tar -xzvf openshift-origin-client-tools-v1.3.0-3ab7af3d097b57f933eccef684a714f2368804e7-linux-64bit.tar.gz
RUN mv openshift-origin-client-tools-v1.3.0-3ab7af3d097b57f933eccef684a714f2368804e7-linux-64bit/oc /bin/oc
RUN chmod +x /bin/oc

# Download Cuberite server (Minecraft C++ server)
# and load up a special empty world for Dockercraft
WORKDIR /srv
RUN sh -c "$(wget -qO - https://raw.githubusercontent.com/cuberite/cuberite/master/easyinstall.sh)" && mv Server cuberite_server
COPY ./world world
COPY ./docs/img/redhat-reverse.png logo.png
COPY ./start.sh start.sh

ADD ./go/src/kubeproxy/kubeproxy /bin/goproxy

EXPOSE 25565 

CMD ["/bin/bash","/srv/start.sh"]
