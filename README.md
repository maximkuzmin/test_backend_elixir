# Backend Test exersize solution by Maxim Kuzmin/Noveo

## How to deploy it
This app has docker-compose file so you can just cd to project dir and run
```
# this will build app image and pull db image
$ docker-compose build

# this initial script will install apps dependencies, prepare database structure and import initial CSV's
$ docker-compose run app bash run_dockerized_app.sh prepare

# after it you can up all docker-compose network as daemon with:
docker-compose up -d

## this one is a bit trickier
# jump into PostGIS container
docker-compose exec postgis bash

# inside the container import GIS dataset. Dataset is free, but belongs to https://www.naturalearthdata.com/
shp2pgsql -I -d -s 4326 -c datasets/ne_10m_admin_0_countries.shp countries | psql -U user -d geospatial_api_dev

# and then just exit from container
exit
```
After that you have completely ready database and app.


 ## Task #1