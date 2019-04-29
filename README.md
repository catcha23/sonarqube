# Counter Service SonarQube Instance

## Introduction

This repository contains everything you need for running SonarQube for Counter Service.

## Overview

This SonarQube configuration is run using the official Docker image provided by SonarSource at https://hub.docker.com/_/sonarqube.

## Deployment

This SonarQube instance runs in Docker on an EC2 instance, and stores all it's data in a PostgreSQL database running on AWS RDS.  Therefore there are main steps to deploying SonarQube:

- Prepare EC2 instance
- Create AWS RDS instance
- Run SonarQube

## Prepare EC2 Instance

SonarQube requires a moderate amount of RAM and disk I/O.  You should allocate a machine with at least 2GB of available RAM to SonarQube.

**Future Enhancement:** infrastructure-as-code for SonarQube instance.

You can use any Linux distribution supported by Docker such as Ubuntu or Debian.  Your EC2 instance does not require any special packages aside from the Docker Engine.

See the Docker documentation for your preferred distribution: 

- CentOS - https://docs.docker.com/install/linux/docker-ce/centos/
- Debian - https://docs.docker.com/install/linux/docker-ce/debian/
- Fedora - https://docs.docker.com/install/linux/docker-ce/fedora/
- Ubuntu - https://docs.docker.com/install/linux/docker-ce/ubuntu/

## Create AWS RDS Instance

TODO

## Run SonarQube

### Deploy Scripts

#### Overview

Launch SonarQube using the supplied start.sh script.

There are two ways you can get this script onto the EC2 instance:

1. SCP the scripts from your local clone to the EC2 instance
2. Install Git on the EC2 instance and pull the scripts directly from the VCS.

The second method is recommended since future changes in the configuration can put on the EC2 instance by just running git pull.

#### SCP Method

TODO

#### Git Method

Ensure Git is available on the EC2 instance - for example on Debian or Ubuntu:

```bash
sudo apt-get update && sudo apt-get install -y git
```

Clone the SonarQube repository (this repository):

```bash
git clone TODO-repository-url
```

### Prepare Docker Volumes

SonarQube needs to store configuration, data and logs on disk.  You will need to provide it will volumes to store these things in - preferably a separate volume for each.

As a simple approach you can bind local host directories to the container.  For example just create the following local paths:

```bash
sudo mkdir -p /dat/sonarqube/conf
sudo mkdir -p /dat/sonarqube/data
sudo mkdir -p /dat/sonarqube/logs
```

And change the permissions so that SonarQube can write to these directories

```bash
sudo chown -R 999:999 /dat/sonarqube
```

And add volume binds to the `start.sh` script:

```bash
sudo docker run -d \
        --name $instanceName \
        --restart always \
        -v /dat/sonarqube/conf:/opt/sonarqube/conf \
        -v /dat/sonarqube/data:/opt/sonarqube/data \
        -v /dat/sonarqube/logs:/opt/sonarqube/logs \
        $containerImage
```

See the Docker Hub documentation page for other volume options: https://hub.docker.com/_/sonarqube?tab=description

### Configure Database Access

Ensure that your EC2 instance has an IAM role that grants it access to the RDS PostgreSQL instance.

Then in the start.sh script add the -e switch to provide the connection string:

```bash
sudo docker run -d \
        --name $instanceName \
        --restart always \
        # Volume binds from previous step here
        -e sonar.jdbc.url=jdbc:postgresql://host/sonar \
        $containerImage
```

### Launch SonarQube

Once everything is ready including preparing volumes, launch SonarQube with the supplied start script:

```bash
cd sonarqube
./start.sh
```

Check that it's running with:

```bash
sudo docker ps
```

