FROM centos:7

ENV XRD_VERSION=4.12.3

RUN yum -y install epel-release \
	&& yum upgrade -y \
	&& yum -y install curl \
	sudo \
	wget \
	nano \
        && yum clean all \
	&& rm -rf /var/cache/yum/* \
	&& yum upgrade -y \
	&& yum -y install --enablerepo="epel" mysql-utilities \
	mysql-connector-python \
	supervisor \
	globus-gridftp-server \ 
	globus-connect-server \
	fetch-crl \
	voms-clients-java \
        && yum clean all \
        && rm -rf /var/cache/yum/*

# Default root dir
ENV XC_ROOTDIR /fefs

RUN curl -o /etc/yum.repos.d/EGI-trustanchors.repo http://repository.egi.eu/sw/production/cas/1/current/repo-files/EGI-trustanchors.repo \
    && yum -y update \
    && yum -y install ca-certificates ca-policy-egi-core && yum clean all

RUN yum install -y openssl xrootd-server-$XRD_VERSION  xrootd-server-devel-$XRD_VERSION xrootd-devel-$XRD_VERSION xrootd-multiuser-$XRD_VERSION

RUN yum install -y xrootd xrootd-server xrootd-client xrootd-client-devel xrootd-python 

RUN yum update -y

RUN yum install -y xrootd xrootd-client

RUN yum install -y https://downloads.globus.org/toolkit/gt6/stable/installers/repo/rpm/globus-toolkit-repo-latest.noarch.rpm \
	&& yum install -y globus-connect-server \
        && yum clean all \
        && rm -rf /var/cache/yum/*

RUN mkdir -p /etc/grid-security/ \
	&& mkdir -p /fefs/Other/rucio_tmp \
	&& chmod 777 /fefs/Other/rucio_tmp/ \
	&& chmod 777 -R /var/log 

RUN groupadd datatrans \
        && useradd -g datatrans  -s /bin/bash -p datatrans datatrans \
	&& mkdir -pv /fefs \
	&& chown datatrans: -R /fefs \
	&& mkdir -pv /var/spool/xrootd \
	&& chown datatrans: -R /var/spool/xrootd \ 
	&& mkdir -pv /var/run/xrootd \
	&& chown datatrans: -R /var/run/xrootd \
	&& mkdir -pv /var/log/xrootd/standalone \
	&& chown datatrans: -R /var/log/xrootd/standalone \
	&& mkdir -pv /tmp/.xrd \
	&& chown datatrans: -R /tmp/ \
	&& chown datatrans: /tmp/.xrd/ \
	&& mkdir -pv /tmp/chkpnt \
	&& chown datatrans: /tmp/chkpnt


# Create storage area
RUN mkdir /rucio
RUN chown datatrans: /rucio

RUN mkdir -p /data && chown -R datatrans: /data

RUN mkdir -p /xrd /var/run/xrootd && chown -R datatrans: /xrd /var/run/xrootd

ADD renew_proxy.sh /
ADD docker-entrypoint.sh /
ADD gridftp.conf /etc/gridftp.conf 
ADD file_simulator.py /
ADD MAGIC_dataset.txt /
ADD CTA_dataset.txt /
ADD run_script.sh / 

ADD xrdrucio.cfg /etc/xrootd/xrdrucio.cfg
ADD httprucio.cfg /etc/xrootd/httprucio.cfg
ADD xrdadler32.sh /usr/local/bin/xrdadler32.sh
RUN chmod 0755 /usr/local/bin/xrd*

ADD Auth-file-http /etc/xrootd/
ADD xrootd-http.cfg /etc/xrootd/

ADD image-config.d/* /etc/osg/image-config.d/
ADD xrootd/* /etc/xrootd/config.d/

EXPOSE 2814
# Please provide the TCP port the first back end should listen to (additional backends will use the subsequent TCP ports, so make sure you have enough unused ports in this range) [2813]: 
EXPOSE 2813
# Please provide the TCP port the front end should listen to [2811]: 
EXPOSE 2811
# inbound connections (GLOBUS_TCP_PORT_RANGE) [20000,25000]
# outbound connections (GLOBUS_TCP_SOURCE_RANGE) [20000,25000]:
EXPOSE 20000-25000

EXPOSE 50000-51000 
EXPOSE 1094 

#Exposing ports Globus's MyProxy uses
EXPOSE 7512

#Exposing ports Globus's OAuth uses
EXPOSE 443

# start centos 7
CMD bash ./docker-entrypoint.sh
