#!/bin/bash

docker pull centos:7
docker build -f Dockerfile -t grid.cta-test-2.pic.es .
docker run -p 80:80 \
	--net=host \
	-p 2814:2814 \
	-p 2813:2813 \
	-p 2811:2811 \
	-p 20000-22000:20000-22000 \
	-p 50000-51000:50000-51000 \
	-h grid.cta-test-2.pic.es \
	--name grid.cta-test-2.pic.es \
	--volume $(pwd)/fefs/:/fefs \
	--volume /sys/fs/cgroup:/sys/fs/cgroup:ro \
	--volume $(pwd)/gridftp.conf:/etc/gridftpd/gridftpd_backend/gridftp.conf \
        --volume $(pwd)/certs/hostcert.pem:/var/lib/globus-connect-server/grid-security/hostcert.pem \
        --volume $(pwd)/certs/hostkey.pem:/var/lib/globus-connect-server/grid-security/hostkey.pem \
        --volume $(pwd)/certs/hostcert.pem:/etc/grid-security/hostcert.pem \
        --volume $(pwd)/certs/hostkey.pem:/etc/grid-security/hostkey.pem \
        --volume $(pwd)/certs/hostcert.pem:/etc/grid-security/xrd/xrdcert.pem \
        --volume $(pwd)/certs/hostkey.pem:/etc/grid-security/xrd/xrdkey.pem \
	--volume $(pwd)/grid-mapfile:/etc/grid-security/grid-mapfile \
        --volume $(pwd)/data:/rucio \
 	-d grid.cta-test-2.pic.es


# get into hadoop master container
docker exec -it grid.cta-test-2.pic.es bash
