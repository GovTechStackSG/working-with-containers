# Working with Containers

In this module, we cover working with Containers, using the popular Docker container runtime.

## Learning Objectives
* [Pulling an Image from a Registry](#pulling-an-image)
* [Running a Container](#running-a-container)
* [Creating your own Image](#creating-your-own-image)
* [Running a web server container](#running-a-web-server-container)
* [Mounting volumes to a container](#mounting-volumes-to-a-container)
* [Networking containers together](#networking-containers-together)
* [Using Docker Compose](#using-docker-compose)

## Pull the Git repo for Working with Containers
For this part of the workshop, we will need some Dockerfiles. Run the following command to retrieve them from our Git Repo.
You will also find a copy of this instructions in the repo.
```bash
cd /home/vagrant
git clone 'https://github.com/GovTechStackSG/working-with-containers.git'  
```

For convenience, these instructions are also available at the following URL, with a copy-to-clipboard button for each code snippet: 

https://govtechstacksg.github.io/working-with-containers/

## Pulling an Image from a Registry
Run the following command to retrieve a Docker image from a registry
```bash
sudo docker image pull centos:latest
```

You can list the images you have on your Docker engine by running the following command:
```bash
sudo docker image ls
```

## Running a Container
We use the image that we pulled to create a running container. Run the following command to start a Bash shell in a centos container.
```bash
sudo docker container run --tty --interactive --rm --name centos-bash centos:latest bash
```

You can do whatever you want in the Bash shell, feel free to alter the contents of your container. Type the `exit` command or
press CTRL + D to exit the Bash shell.

Let's start the container again:
```bash
sudo docker container run --tty --interactive --rm --name centos-bash centos:latest bash
```

Explore the filesystem and see if the changes you have made are still persistent. The container should have reverted to the original
image state.

Run the following command to list the running processes in the container.
```bash
ps -aux
```

As long as you are in the Bash shell, the container is alive. When you exit the shell, the Bash shell process 
that is PID 1 in the container will stop, hence the container will stop too. We added `--rm` to our docker container run arguments,
so the Docker engine will remove the container from the list.    

Let's start the container again in detached mode, and run a separate program called `yes`:
```bash
sudo docker container run --detach --rm --name centos-yes1 centos:latest yes
```

Run the following command to list the running containers on your Docker host:
```bash
sudo docker container ps
```

Let's start a second container in detached mode:
```bash
sudo docker container run --detach --rm --name centos-yes2 centos:latest yes
```

List the running containers again, observe the addition of the second container:
```bash
sudo docker container ps
```

Let's attach a Bash shell to one of the running containers. Run the following command to start a Bash shell:
```bash
sudo docker container exec --tty  --interactive centos-yes1 bash 
``` 

In the Bash Shell, run the following command to list the running processes in the container. Observe that the `yes` program is running in PID 1.
```bash
ps -aux
```

Let's stop and remove the running containers.
```bash
sudo docker rm --force centos-yes1 centos-yes2
```

## Creating your own Image

We will now be building a Node.js web application. Our base template for a Node.js web app is located in the ```backend`` directory`.

Let's take a look at the Dockerfile for the web app. The Dockerfile describes to the Docker engine how to build 
your container image.  


| Directive | Description |
| --- | --- |
| `FROM` | specifies the base image to start from. In our case, we are using a Node.js base image. |
| `COPY` | instructs the Docker engine to copy a path from the current build directory into the container. |
| `USER` | instructs the Docker engine to change the current UID. You can also use usernames for this directive. |
| `RUN` | instructs the Docker engine what commands to run on the shell to prepare your application image. It is possible to specify multiple `RUN` directives, but we join all of them using `&& \` in order to reduce the layers in the image. |
| `VOLUME` | specifies a volume mount path to the Docker engine. You can mount local and remote filesystem paths, to the specified volume mount path, depending on the available Docker storage plugins installed. |
| `EXPOSE` | specifies the ports to expose on the container. To map a host port to the container, you will need to add the `--publish host-port:container-port` argument to your `docker run` command. |
| `CMD` | specifies the default process to run when starting the container (the PID 1 process). |
| `WORKDIR` | instructs the Docker engine to change the current working directory. |

Now that we have covered the basic elements of a Dockerfile, let's build and tag the web app, by running the following command:
```bash
sudo docker image build --tag backend:latest ./backend
``` 

## Running a web server container

We can run the web application server that we built by running the following command:
```bash
sudo docker container run --detach --publish 3000:3000 --name backend backend:latest 
``` 

Let's open a terminal to follow the logs from the web server
```bash
sudo docker container logs --follow backend
```

With another terminal, let's try calling the web server:
```bash
curl 'http://localhost:3000'
```

Observe the incoming HTTP requests.

To clean up, let's remove the container.
```bash
sudo docker container rm --force backend
```

## Mounting volumes to a container

Let's create a static asset web server.


```bash
sudo docker container run --detach --rm --publish 8080:80 \
--name frontend --volume $(pwd)/frontend:/usr/local/apache2/htdocs:z \
httpd:latest 
``` 

Connect to your frontend server. Feel free to modify the contents of the static assets, to verify that you are serving the host files through the volume mount.

With your browser, let's try calling the web server:
```bash
curl "http://localhost:8080"
```

To clean up, let's remove the container.
```bash
sudo docker container rm --force frontend
```

## Networking containers together

We are now going to create your web application stack, complete with load balancers. We are going to create two static 
web servers, two application servers and load balancers for both web and application servers. 

First, we create a network.
```bash
sudo docker network create ha-webservers
```

Let's create the front end servers first
```bash
cd /home/vagrant/working-with-containers

sudo docker container run --net ha-webservers --rm --detach --publish 80 --name frontend1 \
--volume $(pwd)/frontend:/usr/local/apache2/htdocs:z \
httpd:latest

sudo docker container run --net ha-webservers --rm --detach --publish 80 --name frontend2 \
--volume $(pwd)/frontend:/usr/local/apache2/htdocs:z \
httpd:latest
```

Let's create the back end servers
```bash
sudo docker container run --net ha-webservers --detach --rm --publish 3000 --name backend1 backend:latest 

sudo docker container run --net ha-webservers --detach --rm --publish 3000 --name backend2 backend:latest 
```

Let's create the load balancers
```bash
sudo docker container run --net ha-webservers --detach --publish 8080:8080 --name frontend-lb \
--volume $(pwd)/lb:/usr/local/etc/haproxy/cfg:z \
haproxy:latest \
haproxy -f /usr/local/etc/haproxy/cfg/frontend.cfg

sudo docker container run --net ha-webservers --detach --publish 3000:3000 --name backend-lb \
--volume $(pwd)/lb:/usr/local/etc/haproxy/cfg:z \
haproxy:latest \
haproxy -f /usr/local/etc/haproxy/cfg/backend.cfg
```

In separate terminals, follow the container logs:

```bash
sudo docker container logs --follow backend1

sudo docker container logs --follow backend2
```

Open your browser and test the front end and backend. Observe that every request to the backend is load-balanced.

Cleanup the containers and network.

```bash
sudo docker container rm --force frontend1 frontend2 backend1 backend2 frontend-lb backend-lb
sudo docker network rm ha-webservers
```

## Using Docker Compose

Up till this point we've been manually specifying all the parameters to the Docker engine. We can also capture all of
these parameters in a Docker Compose file. Use your editor to view the docker-compose.yaml file.

Run the following command to bring up the entire stack that we created earlier.

```bash
sudo docker-compose up -d --build
```

Run the following command to bring down the stack.
```bash
sudo docker-compose down
```

