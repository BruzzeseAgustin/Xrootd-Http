#!/bin/bash

DOCKER_CONTAINER_LIST='grid.cta-test-2.pic.es'
echo 'y' | docker stop $DOCKER_CONTAINER_LIST; 
docker rm $DOCKER_CONTAINER_LIST; 

