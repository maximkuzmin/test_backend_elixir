defmodule GeospatialApi.Repo do
  use Ecto.Repo,
    otp_app: :geospatial_api,
    adapter: Ecto.Adapters.Postgres
end
