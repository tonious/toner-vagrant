#!/bin/bash

set -e

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
  python-dev libbz2-dev libicu-dev libboost-all-dev \
  postgis postgresql-9.3-postgis-2.1 postgresql-9.3-postgis-2.1-scripts \
  golang libleveldb-dev mercurial supervisor

# Tilemill
cd /vagrant/tilemill
npm install

cat <<EOF > /etc/supervisor/conf.d/tilemill.conf
[program:tilemill]
directory = /vagrant/tilemill
command = /vagrant/tilemill/index.js --server=true --listenHost=0.0.0.0
user = root
EOF

# Imposm

mkdir -p /vagrant/imposm3
cd /vagrant/imposm3
export GOPATH=`pwd`
go get github.com/omniscale/imposm3
go install github.com/omniscale/imposm3

# PostGIS

/etc/init.d/postgresql start
echo "CREATE USER vagrant WITH SUPERUSER PASSWORD 'vagrant';" | su -l postgres -c psql

PATH="${PATH}:/vagrant/imposm3/bin"

# pgexplode

cd /vagrant/pgexplode
npm install

PATH="${PATH}:/vagrant/pgexplode"

# Toner

cd /vagrant/toner-carto
npm install
echo 'DATABASE_URL=postgres://vagrant:vagrant@localhost/toner' > .env
make db && make db/postgis
# make .env data/metro/toronto_canada.osm.pbf 



mkdir -p /root/Documents/MapBox/project
make link

make db/toronto
make db/italy
make db/ontario
make db/OH
make db/shared

cd /vagrant/toner-carto

make toner
#ln -s toner-lines.mml project.mml

# Nik4



echo "${PATH}" > /root/.vagrant

# Everything's installed.
# Let's use supervisor to make sure it's all running.

/etc/init.d/supervisor start
supervisorctl reload
supervisorctl restart all

# Make sure the vagrant user has all of these tools in $PATH.

cat <<EOF
Done!

Now use 'vagrant ssh' to get a console.

EOF
