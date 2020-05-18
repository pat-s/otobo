# This is the build file for the OTOBO docker image.
# The database will run in a separate container. See docker-compose.yml

# See: https://perlmaven.com/getting-started-with-perl-on-docker
# See: http://mfg.fhstp.ac.at/development/webdevelopment/docker-compose-ein-quick-start-guide/
# See: https://github.com/juanluisbaptiste/docker-otrs/
# See: http://not403.blogspot.com/search/label/otrs

# Here are some commands for Docker newbys:
# show version:           sudo docker version
# build an image:         sudo docker build -t otobo-plack .
# run the new image:      sudo docker run -p 5000:5000 -v opt_otobo:/opt/otobo otobo-plack
# log into the new image: sudo docker run  -v opt_otobo:/opt/otobo -it otobo-plack bash
# show running images:    sudo docker ps
# show available images:  sudo docker images
# list volumes :          sudo docker volume ls
# inspect a volumne:      sudo docker volume inspect opt_otobo

# use the latest Perl on Debian 10 (buster). As of 2020-05-15.
# cpanm is already installed
FROM perl:5.30.2-buster

# install some required Debian packages
RUN apt-get update
RUN apt-get -y install tree vim nano default-mysql-client

# create /opt/otobo and use it as working dir
RUN mkdir /opt/otobo
COPY . /opt/otobo
WORKDIR /opt/otobo

# Found no easy way to install with --force in the cpanfile
RUN cpanm --force XMLRPC::Transport::HTTP
RUN cpanm --force Net::Server

# The modules in /opt/otobo/Kernel/cpan-lib are not considered by cpanm.
# This hopefully reduces potential conflicts.
RUN (bin/otobo.CheckModules.pl --cpanfile > cpanfile) && cpanm --with-feature plack --with-feature=mysql --installdeps .

# start the webserver
CMD plackup --server Starman --port 5000 bin/psgi-bin/otobo.psgi