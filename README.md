High Performance MySQL Sandbox
==============================

![high performance mysql](./high-performance-mysql.png)

Recently I finished reading High Performance MySQL by Baron Schwartz, Peter
Zaitsev and Vadim Tkachenko. The book covers replication, partitioning,
benchmarking, query analysis, etc. This repo is a collection of little
"sandbox" environments I created to just kick-the-tires and try stuff out.

The first thing I'm going to try is setting up MySQL replication using docker
and docker-compose. I'll use a container with tmux and tmuxinator to make a
visualization.

Files
-----
- Dockerfile-tmuxinator
A dockerfile that builds an image with tmux, tmuxinator, vim and the docker
client binaries. The container created from this image will have the docker
socket mounted within it so the client docker library in the container can 
communicate with the host's dockerd.

Replication Demo Usage
----------------------
```
$ ./replication/start.sh
```

Notes...
```
# build visualization container image
$ docker build -f ./Dockerfile-tmuxinator -t tmuxinator .

# start the containers
$ cd replication
$ docker-compose build
$ docker-compose up

# start visualization container
# IN ./replication/
$ docker run \
    --rm \
    -it \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v ./:/root \
    --network replicatoin_default \
    --name tmuxinator \
    tmuxinator:latest \
    tmuxinator start -p /root/tmuxinator-replication.yml
```

NOTE:
- get tmux layout
`docker exec tmuxinator tmux list-windows | sed -n 's/.*layout \(.*\)] @.*/\1/p'`
