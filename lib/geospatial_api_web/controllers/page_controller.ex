defmodule GeospatialApiWeb.PageController do
  use GeospatialApiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
