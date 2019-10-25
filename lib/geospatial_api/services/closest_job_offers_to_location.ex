defmodule Services.ClosestJobOffersToLocation do
  import Ecto.Query, only: [from: 2]
  import Geo.PostGIS
  alias GeospatialApi.{Repo, JobOffer}

  def call(%{longitude: long, lattitude: lat, radius: radius_in_km}) do
    radius = radius_in_km * 1000
    point = %Geo.Point{coordinates: {long, lat}, srid: 4326}

    query =
      from j in JobOffer,
        select: [
          j,
          fragment("ST_distance_sphere(?,?) as distance", j.office_location, ^point)
        ],
        where: fragment("ST_distance_sphere(?,?) <= ?", j.office_location, ^point, ^radius),
        order_by: fragment("distance ASC"),
        limit: 50

    Repo.all(query)
  end
end
