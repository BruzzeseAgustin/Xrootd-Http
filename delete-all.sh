#!/bin/bash

echo 'y' | docker stop container grid.cta-test-2.pic.es

echo 'y' | docker system prune

echo 'y' | docker image prune -a
