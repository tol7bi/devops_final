#!/bin/bash

# Stop existing Traefik job if it exists
nomad job stop traefik

# Validate the job file
nomad job validate traefik.nomad

# Run the new job
nomad job run traefik.nomad

# Check job status
nomad job status traefik