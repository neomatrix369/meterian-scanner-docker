# Meterian Scanner Docker Container

Scan for vulnerabilities in your project using the Meterian Scanner Docker container 

## How to use the docker container

- Use an environment variable by the name METERIAN_API_TOKEN containing the secret Meterian token:
    - Create an account or log into your account on http://meterian.com
    - Create an new secret API token from the dashboard
    - Create an environment variable by the name METERIAN_API_TOKEN containing this token
    - This is a one off setup for a given environment
- Place yourself into a project that you wish to scan
- Use the below command to execute the container:
```bash
    docker run -it                                          \
           --volume ${PWD}/:/workspace/                     \
           --workdir /workspace/                            \
           --env METERIAN_API_TOKEN="${METERIAN_API_TOKEN}" \
           meterian-bot/meterian-scanner-docker:v0.1
```

### Output of successful execution



## Additional option(s) to run the docker container

```bash
    docker run -it                                          \
           --volume ${PWD}/:/workspace/                     \
           --workdir /workspace/                            \
           --env METERIAN_API_TOKEN="${METERIAN_API_TOKEN}" \
           --env METERIAN_CLI_ARGS="[Meterain CLI Options]" \ 
           meterian-bot/meterian-scanner-docker:v0.1
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