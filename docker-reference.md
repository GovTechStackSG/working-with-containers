# Docker Reference
List container images
```bash
docker image ls
```

Pull a container image
```bash
docker image pull centos:latest
```

Run a container
```bash
docker container run --detach --name centos centos:latest
```

Run a container and map a local port to the container port
```bash
docker container run --detach --name httpd --publish 8080:8080 httpd:latest
```

Run a container interactively
```bash
docker container run --tty --interactive --name centos-bash centos bash
```

Run an additional command in a container interactively
```bash
docker container exec --tty --interactive --name centos-bash centos bash
```

List container logs
```bash
docker container logs httpd
```

List containers
```bash
docker container ps
```

Remove container
```bash
docker container rm --force httpd centos centos-bash
```

Remove all containers
```bash
docker container rm --force $(docker container ls --all --quiet)
```

Remove all images
```bash
docker image rm --force $(docker image ls --all --quiet)
```
