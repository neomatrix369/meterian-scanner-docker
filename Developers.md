# Developers

This read me file is meant for the benefit of the developers who will be maintaiing this project at Meterian.

## Scripts provided

Below are list of scripts provided to create and upload the docker image to the Docker registory:

```
build/
   Dockerfile
   entrypoint.sh

   buildDockerImage.sh
   push-docker-image-to-hub.sh

   removeUnusedContainersAndImages.sh
runInDockerContainer.sh
```

## Initial setup (one-off)

Ensure a test Meterian API token has been created and stored in the environment variable called `METERIAN_API_TOKEN`. 

Also to be able to upload the build docker image to Docker Hub, `DOCKER_USER_NAME` and `DOCKER_PASSWORD` must be setup as well with the valid data for the Docker Hub user `meterianbot`.

This applies to the following environments:

- local machine
- CircleCI or any other CI/CD environment

## Workflow

Basically we take an existing Java + Maven based container and package the Meterian Client Jar into it and make it possible for the end-user to point the container to a project in a workspace and run the scanner on the project.

In order, to keep the Docker image up-to-date we need to ensure that with every change to the docker scripts (in this repo/project) and the Meterian Client, we are updating the docker image on Docker Hub.

## Building the docker image

In addition the ```version.txt``` is used by most of the above scripts to refer to a fixed version of the docker image and should be changed when moving to the next version of the container. 

Thereafter please run the below commands to update the image in the Docker registory:

```
    cd build
    ./buildDockerImage.sh
```

The `Dockerfile` and `entrypoint` are the two files used to create the image.

## Pushing the docker image to Docker Hub

Once the setup is in place, as mentioned in the *Initial setup (one-off)* section. Run the below command to push the image to Docker Hub:

```
   cd build
   ./push-docker-image-to-hub.sh
```

You will be promoted the password for the `meterianbot` user. Something like the below should appear when completed successfully:

```
Docker image 'meterianbot/meterian-scanner-docker:v0.1' found in the local repository
Password:
Login Succeeded
The push refers to repository [docker.io/meterianbot/meterian-scanner-docker]
beaa43e48d5b: Pushed
e1ba90e3e741: Pushed
33c194936dca: Pushed
9611d9b23e74: Mounted from library/maven
78aa4a361f09: Mounted from library/maven
e8e447c3ffd4: Mounted from library/maven
3bd8e714d5ee: Mounted from library/maven
be2e590f31f3: Mounted from library/maven
ea20c4bf3aae: Mounted from library/maven
2c8d31157b81: Mounted from library/maven
7b76d801397d: Mounted from library/maven
f32868cde90b: Mounted from library/maven
0db06dff9d9a: Mounted from library/maven
v0.1: digest: sha256:cf067b9283cac7ca5c6a2b8fb9b9f30880804d7638a3c792559ea89a90712fd0 size: 3047
```

## Running the docker container

Also `runInDockerContainer.sh` to run the image after it has been build  The end-users can use this as a template to run the container on their end. Although other examples are provided in the [README.md](README.md).

## Housekeeping

Every now and then we will encounter dangling images or a history of run containers, `removeUnusedContainersAndImages.sh` helps clean them all up.

---

[Return to the README.md](./README.md)