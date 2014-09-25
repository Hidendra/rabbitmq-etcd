#!/bin/bash

if [ -f /.configured ]; then
	echo "RabbitMQ password already set!"
	exit 0
fi

# We need constant fully qualified node name, because hostname changes
echo "RABBITMQ_NODENAME=rabbitmq@localhost" >> /etc/rabbitmq/rabbitmq-env.conf

touch /.configured

