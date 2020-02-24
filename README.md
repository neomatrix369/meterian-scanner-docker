# Meterian Scanner Docker container

[![CircleCI](https://circleci.com/gh/MeterianHQ/meterian-scanner-docker/tree/master.svg?style=svg)](https://circleci.com/gh/MeterianHQ/meterian-scanner-docker/tree/master) | [![Meterian Scanner Docker](https://img.shields.io/docker/pulls/meterian/cli.svg)](https://hub.docker.com/r/meterian/cli)

Scan for vulnerabilities in your project using the Meterian Scanner Docker container.

You can do this without having to install any dependencies needed for the Meterian Scanner client to run, and the scan happens in an isolated environment i.e. inside the Docker container.

The Meterian Scanner docker container is available on [Docker Hub](http://hub.docker.com) under the Docker organisation [meterian](https://hub.docker.com/u/meterian), and is called [meterian/cli](https://hub.docker.com/r/meterian/cli).

## How to use the docker container

- It is as simple as running the below command:
```bash
    PWD=$(pwd)
    docker run -it --rm                                     \
           --volume ${PWD}:/workspace                       \
           --env METERIAN_API_TOKEN="${METERIAN_API_TOKEN}" \
           meterian/cli:latest  
```
- Set-up an environment variable by the name `METERIAN_API_TOKEN` containing the secret Meterian API token:
    - Create an account or log into your account on https://www.meterian.com
    - Create an new secret API token from the dashboard
    - Create an environment variable by the name `METERIAN_API_TOKEN` containing this token in startup file (`~/.bashrc`) and execute it so changes are applied (`source ~/.bashrc`)
    - This is a one off setup
- Place yourself into the folder of the project that you wish to scan
- Run the above docker command

#### Point to project at another location

```bash
    WORK_DIR=~/your-project-dir
    docker run -it --rm                                     \
           --volume ${WORK_DIR}:/workspace                  \
           --env METERIAN_API_TOKEN="${METERIAN_API_TOKEN}" \
           meterian/cli:latest  
```

### Examples of an output after running the docker container on a project

#### Successful execution:

<details><summary>Click to view</summary>

```
© 2017-2020 Meterian Ltd - dockerized version 1.0.0.000

Meterian Client v1.2.7.4, build 7a87b89-307
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
- url:    tmp
- branch: head
- commit: n/a

Java scan - running gradle locally...
- gradle: gradle dependencies generated...
Execution successful!

Uploading dependencies information - 1 found...
Done!

Starting build...
Current build status: in preparation
Current build status: process advices at 2020-02-05T11:48:46.802

Final results: 
- security:	100	(minimum: 90)
- stability:	100	(minimum: 80)
- licensing:	100	(minimum: 95)

Full report available at: 
https://www.meterian.com/projects.html?pid=...

Build successful!
```
</details>

#### Failed execution

<details><summary>Click to view</summary>

```
© 2017-2020 Meterian Ltd - dockerized version 1.0.0.000

Meterian Client v1.2.7.4, build 7a87b89-307
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
- url:    tmp
- branch: 1.0
- commit: n/a

Java scan - running maven locally...
- maven: loading dependency tree...
- maven: dependencies generated...
Execution successful!

Uploading dependencies information - 5 found...
Done!

Starting build...
Current build status: in preparation
Current build status: process advices at 2020-02-05T13:46:58.335

Final results: 
- security:	35	(minimum: 90)
- stability:	99	(minimum: 80)
- licensing:	0	(minimum: 95)

Full report available at: 
https://www.meterian.com/projects.html?pid=...

Build unsuccessful!
Failed checks: [security, licensing]
```
</details>


The exit code for the above executions are respectively `0` and `5`. These can be verified by dumping the exit code in your terminal right after the execution (`echo $?`), and they reflect the correct Meterian Client exit codes documented in the [PDF manual](https://www.meterian.com/documents/meterian-cli-manual.pdf):

> #### Controlling the exit code
> Specific arguments are at your disposal to control the exit code of the client based on the score, --min-security and  --min-stability (plus --min-licensing if the feature is enabled on your account). These are the minimal scores: if not met, the build will have a positive exit code , which will be reported as a failure to the shell and will, most probably, stop your pipeline to progress. In case of error the code will be calculated using a bitmask over the exit code: +1 for a fail on the security score, +2 for a fail on the stability score, +4 for a fail on the licensing score.
> The default values for these scores are 90 for security and 80 for stability


## Additional option(s) to use with the Docker container

The dockerized client accepts all the `[Meterain CLI Options]`.

You can find out more about these options via the [Meterian PDF manual](https://www.meterian.com/documents/meterian-cli-manual.pdf) or by [downloading the client](https://www.meterian.com/downloads/meterian-cli.jar) and running `java -jar meterian-cli.jar --help`.
