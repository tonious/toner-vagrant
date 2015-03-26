#!/bin/bash

set -e

if false; then

# System wide packages.
apt-get -y update
apt-get install -y python-software-properties git zip vim tmux
apt-add-repository -y ppa:chris-lea/node.js
apt-add-repository -y ppa:ubuntugis/ubuntugis-unstable 
apt-get -y update
apt-get -y dist-upgrade 

apt-get -y install nodejs mapnik-utils gdal-bin \
  autoconf build-essential cmake docbook-mathml \
  docbook-xsl libboost-dev libboost-filesystem-dev libboost-timer-dev \
  libcgal-dev libcunit1-dev libgdal-dev libgeos++-dev libgeotiff-dev \
  libgmp-dev libjson0-dev libjson-c-dev liblas-dev libmpfr-dev \
  libopenscenegraph-dev libpq-dev libproj-dev libxml2-dev \
  postgresql-server-dev-9.3 xsltproc git build-essential wget \
  postgresql postgresql-contrib-9.3 protobuf-compiler libprotobuf-lite8 \
  libprotobuf-dev libwebkit-dev libfreetype6-dev libjpeg-dev libpng-dev \
  libcairo2 libcairo2-dev python-cairo python-cairo-dev \
  python-dev libbz2-dev libicu-dev libboost-all-dev 


# Tilemill
cd /vagrant/tilemill
npm install

# Imposm

# PostGIS

/etc/init.d/postgresql start


#echo "CREATE USER gisuser WITH SUPERUSER PASSWORD 'vagrant';" | su -l postgres -c psql

fi
# Toner

cd /vagrant/toner-carto
npm install
echo 'DATABASE_URL=postgres://vagrant:vagrant@localhost/toner' > .env
make db && make db/postgis
make .env db/OH

# Nik4


# Everything's installed.
# Let's use supervisor to make sure it's all running.


# Make sure the vagrant user has all of these tools in $PATH.


cat <<EOF
Done!

Now use `vagrant ssh` to get a console.

EOF
