FROM ubuntu:14.04
MAINTAINER Tyler Blair <hidendra@griefcraft.com>
# Scripts from: https://github.com/skrat/rabbitmq-etcd

RUN apt-get update

# trust rabbitmq dev team key
WORKDIR /tmp
RUN apt-get -y install curl
RUN curl -L "http://www.rabbitmq.com/rabbitmq-signing-key-public.asc" -o key.asc
RUN apt-key add key.asc
RUN rm key.asc

# include rabbitmq and other requirements
RUN echo "deb http://www.rabbitmq.com/debian/ testing main" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y install binutils curl python python-pip build-essential python-dev libffi-dev libssl-dev rabbitmq-server
RUN apt-get -y upgrade
RUN apt-get clean

# Enable web management
RUN rabbitmq-plugins enable rabbitmq_management

# Installs Configuration Synchronization service
RUN pip install pyrabbit
RUN pip install python-etcd

# Add and run scripts
ADD configure.sh /configure.sh
RUN chmod 755 /configure.sh
RUN /configure.sh

ADD configsync.py /configsync.py
RUN chmod 755 /configsync.py

ADD run.sh /run.sh
RUN chmod 755 /run.sh

# RabbitMQ ports
EXPOSE 5672 15672

CMD ["/run.sh"]

