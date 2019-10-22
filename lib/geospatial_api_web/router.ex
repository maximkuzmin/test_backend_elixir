defmodule GeospatialApiWeb.Router do
  use GeospatialApiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", GeospatialApiWeb do
    pipe_through :api

    get "/jobs_in_radius", JobsInRadiusController, :index
  end

  scope "/", GeospatialApiWeb do
    pipe_through :browser
  end

  # Other scopes may use custom stacks.
  # scope "/api", GeospatialApiWeb do
  #   pipe_through :api
  # end
end
