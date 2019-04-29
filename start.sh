#!/bin/bash

prefix=`cat container_prefix`
name=`cat container_name`
containerImage=sonarqube:7.7-community
instanceName=${prefix}_${name//\//_}

sudo docker run -d \
	--name $instanceName \
	--restart always \
	-p 9000:9000 \
	$containerImage
