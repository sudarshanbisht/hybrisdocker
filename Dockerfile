FROM hybrisdummy:1.0
MAINTAINER Stefan Lehmann <stefan.lehmann@unic.com>

ENV VERSION 8
ENV UPDATE 121
ENV BUILD 13

ENV GOSU_VERSION 1.9

#ENV JAVA_HOME /usr/lib/jvm/java-${VERSION}-oracle
#ENV JRE_HOME ${JAVA_HOME}/jre
RUN yum install -y rsync zip unzip

# grab gosu for easy step-down from root
ENV HYBRIS_HOME=/app/hybris/
ENV PLATFORM_HOME=/app/hybris/bin/platform/
ENV PATH=$PLATFORM_HOME:$PATH

# add hybris user

# define hybris home dir as volume
#VOLUME /home/hybris
VOLUME /app/latest-hybris/hybris/temp/hybris/hybrisServer /home/hybris
VOLUME state/media /app/hybris/data/media
VOLUME state/hsql /app/hybris/data/hsqldb


# expose hybris ports
EXPOSE 9001
EXPOSE 9002

# expose default solr port
EXPOSE 8983

# expose the default debug port for connecting via IDE
EXPOSE 8000

# copy the entrypoint script over
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# copy the update system config to image
COPY updateRunningSystem.config /home/hybris/updateRunningSystem.config
WORKDIR /home/hybris

# set entrypoint of container
ENTRYPOINT ["/entrypoint.sh"]

CMD ["run"]
