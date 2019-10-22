defmodule GeospatialApiWeb.JobsInRadiusController do
  use GeospatialApiWeb, :controller
  import Ecto.Query, only: [from: 2]
  import Geo.PostGIS
  alias GeospatialApi.{Repo, JobOffer}

  def index(conn, %{"long" => long, "lat" => lat} = params) do
    radius_in_km = get_radius_in_km params["radius"]

    radius = radius_in_km * 1000
    data = make_query({long, lat, radius})
    render conn, "index.json", data: data
  end

  def make_query({long, lat, radius}) do
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

  defp get_radius_in_km(params_val) when is_bitstring(params_val) do
    res = Float.parse(params_val)
    case res do
      {val, _} -> val
      :error -> get_radius_in_km(nil)
    end
  end

  defp get_radius_in_km(params_val) when is_integer(params_val), do: params_val
  defp get_radius_in_km(nil), do: 50


end
