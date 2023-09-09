# mojo_sdk

## Summary
Sets up a new Mojo development environment for Linux (currently only works on x86_64).

**Table of Contents**
* [mojo\_sdk](#mojo_sdk)
  * [Summary](#summary)
  * [Setup](#setup)
  * [Quickstart](#quickstart)
  * [Development](#development)
  * [TODO](#todo)
  * [Further Reading](#further-reading)

## Setup
* Sign up for a free developer account at [Modular](https://developer.modular.com/signup)
* Install
  * make
    * [Debian/Ubuntu](https://www.gnu.org/software/make/)
    * [macOS](https://www.freecodecamp.org/news/install-xcode-command-line-tools/)
  * [Docker](https://docs.docker.com/get-docker/)
  * [editorconfig](https://editorconfig.org/)
  * [wsl](https://docs.microsoft.com/en-us/windows/wsl/setup/environment)

## Quickstart
* Docker
    ```bash
    # build docker container
    docker-compose build --pull

    # run oneshot docker container
    docker run -it --rm -v $(pwd):/app --workdir=/app --env-file=.env mojo_sdk-app bash

    # start docker container
    docker-compose up -d

    # exec into docker container
    docker-compose exec -it mojo-sdk bash

    # stop docker container
    docker-compose stop

    # remove docker container with volumes
    docker-compose down -v
    ```
* Mojo
  * Authenticate and install the Mojo SDK
    ```bash
    # authenticate
    modular auth $MODULAR_AUTH

    # install mojo
    modular install mojo
    ```

## Development
```bash
# install dependencies (e.g., git, ansible, etc.)
./bootstrap install

# install tools and runtimes (cf. xcode, brew, asdf, poetry, etc.)
./bootstrap <run|run-dev>   # dev only runs plays w/tags and is verbose

# install git hooks
./bootstrap install-precommit

# update git hooks
./bootstrap update-precommit
```

## TODO
* [Open Issues](https://github.com/pythoninthegrass/mojo_sdk/issues)
* Test on x86_64
  * ~~macOS~~
    * [Not supported yet](https://github.com/modularml/mojo/issues/510)
  * Ubuntu
  * Fedora
* QA [Ansible playbook](ansible/playbook.yml)
* Write boilerplate pytest tests
* CI/CD

## Further Reading
* [Mojo Developer Console](https://developer.modular.com/download)
* [Modular Docs - Hello, world!](https://docs.modular.com/mojo/manual/get-started/hello-world.html)
* [python](https://www.python.org/)
* [asdf](https://asdf-vm.com/guide/getting-started.html#_2-download-asdf)
* [poetry](https://python-poetry.org/docs/)
* [docker-compose](https://docs.docker.com/compose/install/)
* [pre-commit hooks](https://pre-commit.com/)
