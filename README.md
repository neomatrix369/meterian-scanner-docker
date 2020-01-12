# Meterian Scanner Docker container

[![CircleCI](https://circleci.com/gh/MeterianHQ/meterian-scanner-docker/tree/master.svg?style=svg)](https://circleci.com/gh/MeterianHQ/meterian-scanner-docker/tree/master) | [![Meterian Scanner Docker](https://img.shields.io/docker/pulls/meterian/cli.svg)](https://hub.docker.com/r/meterian/cli)

Scan for vulnerabilities in your project using the Meterian Scanner Docker container.

You can do this without having to install any dependencies needed for the Meterian Scanner client to run, and the scan happens in an isolated environment i.e. inside the Docker container.

The Meterian Scanner docker container is available on [Docker Hub](http://hub.docker.com) under the Docker organisation [meterian](https://hub.docker.com/u/meterian), and is called [meterian/cli](https://hub.docker.com/r/meterian/cli).

## How to use the docker container

- It is as simple as running the below command:
```bash
    docker run -it --rm                                     \
           --volume ${PWD}/:/workspace/:ro                  \
           --workdir /workspace/                            \
           --env METERIAN_API_TOKEN="${METERIAN_API_TOKEN}" \
           meterian/cli:latest  
```
- Set-up an environment variable by the name METERIAN_API_TOKEN containing the secret Meterian API token:
    - Create an account or log into your account on https://www.meterian.com
    - Create an new secret API token from the dashboard
    - Create an environment variable by the name METERIAN_API_TOKEN containing this token
    - This is a one off setup
- Place yourself into the folder of the project that you wish to scan
- Run the above docker command

#### Point to project at another location (using an environment variable)

TBC

### Examples of an output after running the docker container on a project

TBC

```
Meterian Client v1.2.3.1, build 89b921b-202
All rights reserved
- running locally:   yes
- interactive mode:  on
- minimum security:  90
- minimum stability: 80
- working on folder: /workspace
- autofix mode:      off

```

#### Failed execution

TBC

```
Meterian Client v1.2.3.1, build 89b921b-202
All rights reserved
- running locally:   yes
- interactive mode:  on
- minimum security:  90
- minimum stability: 80
- working on folder: /workspace
- autofix mode:      off

```

The exit code of... TBC


## Additional option(s) to use with the Docker container

TBC

`[Meterain CLI Options]` - you can find out more about additional options via the [Meterian PDF manual](https://www.meterian.com/documents/meterian-cli-manual.pdf) or by [downloading the client](https://www.meterian.com/downloads/meterian-cli.jar) and running `java -jar meterian-cli.jar --help`.


## Developers

See [Developers.md](Developers.md) for development details.
