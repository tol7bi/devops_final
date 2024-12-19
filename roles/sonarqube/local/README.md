# Sonarqube local

This repository contains Dockerfile for Sonarqube configuration. It will install sonarqube and make configurations

## Contents

- [Pre-requisites](#pre-requisites)
- [Usage](#usage)

## Pre-requisites

- Docker running

## Usage

This section contains step-by-step guide how to setup Sonarqube using Dockerfile.
To use this configs locally there is a ready Makefile with the following commands.

```bash
make build   # It will build image
make run     # It will create network and start container
```

Check that everything is working going to localhost:9000, you can login with default
credentials `username: admin password: admin`

To analyze code run following command.

```bash
make analyze
```

Video instruction how make report for code analyse locally:
[YouTube Video](https://youtu.be/6ZRkJ2ofDRE)

To clean up after test run command.

```bash
make clean
```