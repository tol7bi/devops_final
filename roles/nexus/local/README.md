# Nexus local

This repository contains Makefile that deploy Nexus locally

## Contents

- [Pre-requisites](#pre-requisites)
- [Usage](#usage)

## Pre-requisites

- Docker running

## Usage

This section contains step-by-step guide how to setup Nexus locally, using Docker.
To use this configs locally there is a ready Makefile with the following commands.

```bash
make run   # It will pull image from Sonatype/nexus3 and start container
```

Wait 1-2 minutes for Nexus to start
Check that everything is working going to **localhost:8081**. 
You can login with default credentials `username: admin` and to get password run these commands:

```bash
docker exec -it nexus bash # Сonnection to nexus container
cat /nexus-data/admin.password
```

To clean up after test run command:

```bash
make clean
```

To check status of nexus container run command:

```bash
make status
```