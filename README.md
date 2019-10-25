# Backend Test exersize solution by Maxim Kuzmin/Noveo

## How to deploy it
This app has docker-compose file so you can just cd to project dir and run
```
# this will build app image and pull db image
$ docker-compose build

# this initial script will install apps dependencies, prepare database structure and import initial CSV's
$ docker-compose run app bash run_dockerized_app.sh prepare

# after it you can up all docker-compose network as daemon with:
$ docker-compose up -d

## this one is a bit trickier
# jump into PostGIS container
$ docker-compose exec postgis bash

# inside the container import GIS dataset. Dataset is free, but belongs to https://www.naturalearthdata.com/
$ shp2pgsql -I -d -s 4326 -c datasets/ne_10m_admin_0_countries.shp countries | psql -U user -d geospatial_api_dev

# and then just exit from container
$ exit
```
After that you have completely ready database and app.

I chose PostGIS database as main technologies for this solution because it's de-facto standard for all GIS data manipulation.
Elixir + Phoenix were chosen because I'm interested in this language\framework pair.
However, I can admit, that Elixir part could be substituted with virtually any language that has bindings for Postges/PostGIS.

 ## Task #1
 You can run required script by running.
 ```
 $ docker-compose run app mix job_offers_by_category_and_continent
 ```
 You can find script source code at lib/mix/tasks/job_offers_by_category_and_continent.ex and services/job_offers_by_category_and_continent.ex service module.

I can, however, suggest to use solution from Task 2 since beginning, because speed of db request execution is not great for everyday use (about 3 seconds for low-resolution GIS dataset).

 ## Task #2
 To speedup continent statistics calculation, I'll use some key-value storage solution like Redis or ETS to store data with O(1) expenses. This kinds of storages could easily handle 1000 rps, but if event they don't, they are relatively cheap to scale.

 There would be 3 sets of key-values pairs:
 1) rough coordinates pairs keys  like "long:3:lat49:continent" => "Europe" with string value of continent for each pair. On record insertion we can fastly get continent of this rough pair (continents are pretty big and approximation wouldn't hurt)
 2) profession category name duplicates key-values like "profession:30:category" => "TECH" to get profession category without joins
 3) "continent:Europe:category:TECH" => integer pairs to fastly access and increment/decrement on JobOffers table insertions/deletions
 in Ruby-like pseudocode it could look like:
 ```
    def update_continent_statistics(location) do
        rough_lat = location.lat.round
        rough_long = location.long.round
        cont = KeyValStore.get("long:#{long}:lat:#{lat}:continent")
        category_name = KeyValStore.get("profession:#{profession_id}:category")
        KeyValStore.increment("continent:#{continent}:category:#{category_name}")
    end
 ```
 With this solution it could be relatively cheap to get statistics of this kind with 0(N) time where N is count of category names, that should be relatively small number.

 ## Task #3
 Visit [http://localhost:4000/api/jobs_in_radius?lattitude=48&longitude=2.5&radius=50](http://localhost:4000/api/jobs_in_radius?lattitude=48&longitude=2.5&radius=50) to check the result JSON and play with params.
Source code for this endpoint can be found at lib/geospatial_api_web/controllers and services/closest_job_offers_to_location.ex service module
