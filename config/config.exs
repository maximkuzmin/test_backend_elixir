# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config


config :geospatial_api,
  ecto_repos: [GeospatialApi.Repo]

# Configures the endpoint
config :geospatial_api, GeospatialApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qpjd6dlzmNtcS5oiOnsSZztGRVIDMSbi8Lbiwyd+y9yjn7fk2MrQ5HsyRgGiocTc",
  render_errors: [view: GeospatialApiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: GeospatialApi.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
