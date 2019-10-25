defmodule GeospatialApiWeb.JobsInRadiusView do
  def render("index.json", %{data: data}) do
    %{
      job_offers: Enum.map(data, &to_json/1)
    }
  end

  defp to_json([job_offer, distance_in_meters]) do
    %{
      name: job_offer.name,
      contract_type: job_offer.name,
      distance: Float.round(distance_in_meters / 1000, 1)
    }
  end
end
