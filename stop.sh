#!/bin/bash

prefix=`cat container_prefix`
name=`cat container_name`
instanceName=${prefix}_${name//\//_}

sudo docker stop $instanceName
sudo docker rm $instanceName
