Postgrex.Types.define(
  GeospatialApi.PostgresTypes,
  [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),
  []
)
