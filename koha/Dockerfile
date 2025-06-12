FROM ubuntu:25.10

WORKDIR /app
COPY . .

ENV TZ="Europe/Stockholm"

RUN apt update -y
RUN apt upgrade -y

RUN apt clean -y

# Lots from https://github.com/jajm/koha-docker/blob/master/23.05/Dockerfile

RUN apt install -y \ 
	wget \
	gpg \
	vim \
	mysql-server
	
COPY indexdata.gpg /usr/share/keyrings
RUN echo 'deb [signed-by=/usr/share/keyrings/indexdata.gpg] https://ftp.indexdata.com/debian bullseye main' > /etc/apt/sources.list.d/indexdata.list

RUN wget -qO - https://debian.koha-community.org/koha/gpg.asc | \
gpg --dearmor -o /usr/share/keyrings/koha-community-keyring.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/koha-community-keyring.gpg] http://debian.koha-community.org/koha 25.05 main" > \
/etc/apt/sources.list.d/koha-community.list

RUN apt update -y
RUN apt upgrade -y


# From dockerfile above
RUN DEBIAN_FRONTEND=noninteractive \
	PLUGINS_DIR="/usr/lib/rabbitmq/plugins:/usr/lib/rabbitmq/lib/rabbitmq_server-4.0.5/plugins" \
	apt install -y --force-yes --no-install-recommends \
	cpanminus \
    default-libmysqlclient-dev \
    fonts-dejavu \
    gcc \
    gettext \
    git \
    libc6-dev \
    libexpat1-dev \
    libfribidi-dev \
    libgd-dev \
    libxslt1-dev \
    libyaz5-dev \
    make \
    perl \
    pkg-config
##

RUN DEBIAN_FRONTEND=noninteractive \
	PLUGINS_DIR="/usr/lib/rabbitmq/plugins:/usr/lib/rabbitmq/lib/rabbitmq_server-4.0.5/plugins" \
	apt install -y --force-yes  \
	koha-common
	
ADD https://raw.githubusercontent.com/Koha-Community/Koha/v25.05.00-2/cpanfile .

ENV PERL_CPANM_OPT --local-lib-contained /home/koha/.local
RUN export PERL_CPANM_OPT="--quiet --metacpan --notest $PERL_CPANM_OPT" \
	&& cpanm DBD::mysql~'<5' \
	&& cpanm --installdeps . \
	&& rm -rf /home/koha/.cpanm

ENV PERL5LIB /home/koha/koha/lib:/home/koha/koha:/home/koha/.local/lib/perl5
ENV PATH /home/koha/.local/bin:$PATH
ENV LANG C.UTF-8

##


RUN cp koha-sites.conf /etc/koha/koha-sites.conf 

# RUN rm /etc/mysql/koha-common.cnf 
# RUN cp koha-mysql.conf  /etc/mysql/koha-common.cnf

RUN cp apache-ports.conf /etc/apache2/ports.conf 
RUN a2enmod rewrite cgi headers proxy_http
RUN service apache2 restart

CMD ["mysqld_safe", "&"]
