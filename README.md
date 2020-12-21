# Jupyter with Docker
This repository contains installation script for Dockerized Jupyter with additional supported language. The base image is derived from Jupyter Data Science Notebook.

## Requirements
- Docker
- Docker Compose
- Openssl - To generate SSL key
- GNU Make - To run installation script

## Supported Language
- Python 3
- R
- Julia 1.5.3
- Bash *(Additional)*
- Java *(Additional)*
- JavaScript *(Additional)*
- TypeScript *(Additional)*

## Usage:

### Installation
- Run `make install` for first time installation
- You can define a password by changing in Makefile

### Service
- Run `make up` or `make stop` to start up the service or to stop the service container
- Run `make down` to tear down the service

### Cleanup
- Run `make clean` to take down and remove the container *(Note: Your saved files still remain and safe in the local directory.)*
