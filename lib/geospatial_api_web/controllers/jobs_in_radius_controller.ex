defmodule GeospatialApiWeb.JobsInRadiusController do
  use GeospatialApiWeb, :controller
  alias Ecto.Changeset

  def index(conn, params) do
    valid_params = validate_params(params)

    case valid_params do
      {:ok, params} ->
        data = Services.ClosestJobOffersToLocation.call(params)
        render(conn, "index.json", data: data)

      {:error, errors} ->
        conn |> put_status(400) |> render("error.json", errors: errors)
    end
  end

  defp validate_params(params) do
    data = %{}
    types = %{lattitude: :float, longitude: :float, radius: :float}

    changeset =
      {data, types}
      |> Changeset.cast(params, Map.keys(types))
      |> Changeset.validate_required(Map.keys(types))
      |> Changeset.validate_number(:lattitude,
        less_than_or_equal_to: 90.0,
        greater_than_or_equal_to: -90.0
      )
      |> Changeset.validate_number(:longitude,
        less_than_or_equal_to: 90.0,
        greater_than_or_equal_to: -90.0
      )
      |> Changeset.validate_number(:radius, greater_than_or_equal_to: 0)

    if changeset.valid? do
      {:ok, changeset.changes}
    else
      errors = mapped_errors(changeset)
      {:error, errors}
    end
  end

  defp mapped_errors(changeset) do
    Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
