# Meterian Scanner Docker container

[![CircleCI](https://circleci.com/gh/MeterianHQ/meterian-scanner-docker/tree/master.svg?style=svg)](https://circleci.com/gh/MeterianHQ/meterian-scanner-docker/tree/master) | [![Meterian Scanner Docker](https://img.shields.io/docker/pulls/meterianbot/meterian-scanner-docker.svg)](https://hub.docker.com/r/meterianbot/meterian-scanner-docker)

Scan for vulnerabilities in your project using the Meterian Scanner Docker container.

You can do this without having to install any dependencies needed for the Meterian Scanner client to run, and the scan happens in an isolated environment i.e. inside the Docker container.

The Meterian Scanner docker container is available on [Docker Hub](http://hub.docker.com) under the Docker user id [meterianbot](https://hub.docker.com/u/meterianbot), and is called [meterianbot/meterian-scanner-docker](https://hub.docker.com/r/meterianbot/meterian-scanner-docker).

## How to use the docker container

- It is as simple as running the below command:
```bash
    docker run -it --rm                                     \
           --volume ${PWD}/:/workspace/:ro                  \
           --workdir /workspace/                            \
           --env METERIAN_API_TOKEN="${METERIAN_API_TOKEN}" \
           meterianbot/meterian-scanner-docker:v0.1
```
- Set-up an environment variable by the name METERIAN_API_TOKEN containing the secret Meterian API token:
    - Create an account or log into your account on http://meterian.com
    - Create an new secret API token from the dashboard
    - Create an environment variable by the name METERIAN_API_TOKEN containing this token
    - This is a one off setup
- Place yourself into the folder of the project that you wish to scan
- Run the above docker command

#### Point to project at another location (using an environment variable)

#### Absolute path (example 1)

Say you want to scan a project located somewhere on your disk or network, and you know the path to that project, then do the below:

```bash
    WORKSPACE=/path/to/another/valid/project/              && \
        docker run -it --rm                                   \
             --volume ${WORKSPACE}/:/workspace/:ro            \
             --workdir /workspace/                            \
             --env METERIAN_API_TOKEN="${METERIAN_API_TOKEN}" \
             meterianbot/meterian-scanner-docker:v0.1
```

#### Absolute path (example 2)

Say you want to scan a project in some deep-level folder structure, and you know the name of the project (by it's folder name) then do the below: 

```bash
    cd to/some/folder/with/projects
    
    WORKSPACE=${PWD}/project/                              && \
        docker run -it --rm                                   \
             --volume ${WORKSPACE}/:/workspace/:ro            \
             --workdir /workspace/                            \
             --env METERIAN_API_TOKEN="${METERIAN_API_TOKEN}" \
             meterianbot/meterian-scanner-docker:v0.1
```

Note: it is important that the container is made to point to a valid project and best to stick to the semantics of the examples shown in this document in order to be able to run the scanner successfully on a project.
Also please use _absolute path_ when pointing to other project workspaces for the above command to work.

### Examples of an output after running the docker container on a project

#### Successful execution

```

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 METERIAN_API_TOKEN environment variable has been set
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

~~~~~~ Running the Meterian Scanner client ~~~~~~

Meterian Client v1.2.3.1, build 89b921b-202
All rights reserved
- running locally:   yes
- interactive mode:  on
- minimum security:  90
- minimum stability: 80
- working on folder: /workspace
- autofix mode:      off

Checking folder...
Folder /workspace contains a viable project!

Authorizing the client...
Client successfully authorized

Loading build status...
No build running found!

Requesting build...
Build allowed

Project information:
- url:    git@bitbucket.org:meterian-bot/ClientOfMutabilityDetector.git
- branch: master
- commit: 48cb9609df50bcb34aafc081ee990f445dd62d44

JAVA scan - running maven locally...
- maven: loading dependency tree...
- maven: dependencies generated...
Execution successful!

Uploading dependencies information - 14 found...
Done!

Starting build...
Current build status: in preparation
Current build status: process advices at 2019-07-12T19:26:00.518
Current build status: process advices at 2019-07-12T19:26:03.527

Final results:
- security: 100 (minimum: 90)
- stability:  99  (minimum: 80)
- licensing:  97  (minimum: 95)

Full report available at:
https://www.meterian.com/projects.html?pid=43e37555-9b8b-4295-abb1-0aa8cc34412f&branch=master&mode=eli

Build successful!
```

#### Failed execution

```
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 METERIAN_API_TOKEN environment variable has been set
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

~~~~~~ Running the Meterian Scanner client ~~~~~~

Meterian Client v1.2.3.1, build 89b921b-202
All rights reserved
- running locally:   yes
- interactive mode:  on
- minimum security:  90
- minimum stability: 80
- working on folder: /workspace
- autofix mode:      off

Checking folder...
Folder /workspace contains a viable project!

Authorizing the client...
Client successfully authorized

Loading build status...
No build running found!

Requesting build...
Build allowed

Project information:
- url:    git@github.com:neomatrix369/meterian-scanner-docker.git
- branch: master
- commit: 321fda607bc5c21833cf34e63b7b96188931ae79

Starting build...
Current build status: in preparation
Current build status: process advices at 2019-07-12T19:19:57.856

Final results:
- security: N/A (minimum: 90)
- stability:  N/A (minimum: 80)

Full report available at:
https://www.meterian.com/projects.html?pid=5cd56b03-5aec-40d7-b51a-80d0ad3f1fcb&branch=master&mode=eli

Build unsuccessful!
Failed checks: [security, stability]
```

Returns a `-1` exit code if the scan has failed for whatever reason otherwise you get an exit code of `0`. 

You can check with `echo $?` immediately after it finished execution.

## Additional option(s) to use with the Docker container

```bash
    docker run -it --rm                                     \
           --volume ${PWD}/:/workspace/:ro                  \
           --workdir /workspace/                            \
           --env METERIAN_API_TOKEN="${METERIAN_API_TOKEN}" \
           --env METERIAN_CLI_ARGS="[Meterain CLI Options]" \ 
           meterianbot/meterian-scanner-docker:v0.1
```

`[Meterain CLI Options]` - you can find out more about additional options via the [Meterian PDF manual](https://www.meterian.com/documents/meterian-cli-manual.pdf) or by [downloading the client](https://www.meterian.com/downloads/meterian-cli.jar) and running `java -jar meterian-cli.jar --help`.

You will see a list like the below:

```
Meterian Client v1.2.3.1, build 89b921b-200
All rights reserved

 --help         Displays this help end exits(0)
 --clean        Clean any previous build information on the client
 --local        Run this build using the local build system (default: --local=true)
 --interactive      Allow the client to use the browser for interactive authentication (default: --interactive=true)

 [snipped]
```

## Developers

See [Developers.md](Developers.md) for more details on how to amend or manage this project (mostly for the Dev team at Meterian).