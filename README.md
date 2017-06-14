### hybris-base-image

A base image for Hybris Commerce Suite, based on **Centos 7**.

Can be used Out-Of-The-Box for projects based on Hybris Commerce Suite >5.5.


The image on [DockerHub](https://hub.docker.com/r/stefanlehmann/hybris-base-image/ "DockerHub") is built automatically from the Dockerfile in the GitHub source repository.

[![](https://images.microbadger.com/badges/image/stefanlehmann/hybris-base-image.svg)](https://microbadger.com/#/images/stefanlehmann/hybris-base-image "Get your own image badge on microbadger.com")

#### Installed packages

* [gosu](https://github.com/tianon/gosu)
* lsof
* curl
* oracle java 8 (server jre 8u121b13)

#### User

| User   | Group  | uid  | gid  |
|--------|--------|------|------|
| hybris | hybris | 1000 | 1000 |

#### Ports

| Port | Purpose            |
|------|--------------------|
| 9001 | default HTTP port  |
| 9002 | default HTTPS port |
| 8983 | default SOLR port  |
| 8000 | default DEBUG port |

The image exposes ``9001`` and ``9002`` for access to the hybris Tomcat server via HTTP and HTTPS.

Also the default Solr server port ``8983`` is exposed.
> Please be aware that in non dev environments the Solr server(s) should run in own container(s).

If you like to debug via your IDE on the running server you can use the exposed ``8000`` port.

#### Volumes
The hybris home directory `/home/hybris` is marked as volume. This volume has the artifacts copied after ant production on base machine.

#### How to add your code

Using a Dockerfile you can copy the output archives, generated using ``ant production``, into the hybris home directory of the image. The [entrypoint-script](entrypoint.sh) will unzip them when the container starts.

If you want you can copy unzipped content too, but this will bloat the images you push to your own repository.

	FROM sudarshanbisht/hybrispoc:1.0
	MAINTAINER Sudarshan Bisht

	# copy the build packages over
	COPY hybrisServer*.zip /home/hybris/

#### Configuration support

For support of different database configurations per container the following environment variables can be set when starting a container.
They will be used to add the properties in second column to ``local.properties`` file.

| Environment variable | local.properties          								|
|----------------------|--------------------------------------------------------|
| HYBRIS_DB_URL        | db.url=$HYBRIS_DB_URL           						|
| HYBRIS_DB_DRIVER     | db.driver=$HYBRIS_DB_DRIVER     						|
| HYBRIS_DB_USER       | db.username=$HYBRIS_DB_USER    						|
| HYBRIS_DB_PASSWORD   | db.password=$HYBRIS_DB_PASSWORD 						|
| HYBRIS_DATAHUB_URL   | datahubadapter.datahuboutbound.url=$HYBRIS_DATAHUB_URL |

Of course you can also build with defaults like ``db.url=jdbc:mysql://database-container/database?useConfigs=maxPerformance&characterEncoding=utf8`` in your ``local.properties`` and use the linking functionality of docker to inject the correct container name which should be mapped to ``database-container``.

##### Clustering

For easy clustering the [entrypoint-script](entrypoint.sh) adds the property ``cluster.broadcast.method.jgroups.tcp.bind_addr`` with currently used container-IP-adress to `local.properties`.
Please be aware that this only happens on first start of the container, so when you restart the container and maybe get another ip this can lead to not working clustering.

#### How to use

1. Create a new image named as hybrisfull using the docker file.

	#docker build -t hybrispoc:1.0 . 

2. Use the image to start the hybris platfrom using the docker-compose.yaml file. Please make sure that you are running thebbelow command from the same location where this docker-compose.yaml file is kept.

	#docker-compose up -d platform

3. Check docker status with below command.

	#docker ps

	#docker logs -f <container id>
