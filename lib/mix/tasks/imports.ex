defmodule Mix.Tasks.ImportProfessions do
  alias GeospatialApi.{Profession, Repo, JobOffer}
  use Mix.Task

  @short_doc "import initial CSV data for professions and job_offers"
  def run(_) do
    Mix.Task.run "app.start"
    Repo.delete_all JobOffer
    Repo.delete_all Profession
    File.stream!("data/technical-test-professions.csv")
      |> CSV.decode(headers: true)
      |> Enum.each(&insert_profession(&1))

    File.stream!("data/technical-test-jobs.csv")
      |> CSV.decode(headers: true)
      |> Enum.each(&insert_job_offer(&1))
  end

  defp insert_profession({:ok, row}) do
    attrs = %{
      id: row["id"],
      name: row["name"],
      category_name: row["category_name"]
    }
    Repo.insert Profession.import_changeset(%Profession{}, attrs)
  end

  def insert_job_offer({:ok, row}) do
    %{"office_latitude" => lat, "office_longitude" => long} = row
    office_location = %Geo.Point{coordinates: {long, lat}, srid: 4326}
    attrs = %{
      office_location: office_location,
      profession_id: row["profession_id"],
      name: row["name"],
      contract_type: row["contract_type"]
    }
    Repo.insert JobOffer.insertion_changeset(%JobOffer{}, attrs)
  end
end
