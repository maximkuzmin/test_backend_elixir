defmodule GeospatialApi.JobOffer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "job_offers" do
    field :contract_type, :string
    field :name, :string
    field :profession_id, :integer
    field :office_location, Geo.PostGIS.Geometry

    timestamps()
  end

  @doc false
  def insertion_changeset(job_offer, attrs) do
    job_offer
      |> cast(attrs, [:profession_id, :contract_type, :name, :office_location])
      |> validate_required([:profession_id, :contract_type, :name, :office_location])
      |> validate_office_location
  end

  defp validate_office_location(changeset) do
    {long, lat} = geopoint = changeset.changes.office_location.coordinates
    if valid_geo_val?(long) && valid_geo_val?(lat) do
      add_error(changeset, :office_location, "wrong office coordinates")
    else
      changeset
    end
  end

  defp valid_geo_val?(str) do
    present_str = String.length(str) > 1
    parsed_float = Float.parse(str)
    case parsed_float do
      :error ->
        false
      {val, _} ->
        present_str && val <=90 && val >= -90
    end
  end
end
