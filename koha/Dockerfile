FROM ubuntu:25.10

ENV TZ="Europa/Stockholm"

RUN apt update -y
RUN apt upgrade -y

RUN apt clean -y

RUN apt install -y wget gpg

RUN wget -qO - https://debian.koha-community.org/koha/gpg.asc | \
	gpg --dearmor -o /usr/share/keyrings/koha-community-keyring.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/koha-community-keyring.gpg] http://debian.koha-community.org/koha 25.05 main" > \
	/etc/apt/sources.list.d/koha-community.list

RUN apt update -y
RUN apt upgrade -y

RUN DEBIAN_FRONTEND=noninteractive \
	PLUGINS_DIR="/usr/lib/rabbitmq/plugins:/usr/lib/rabbitmq/lib/rabbitmq_server-4.0.5/plugins" \
	apt install -y --force-yes  koha-common
