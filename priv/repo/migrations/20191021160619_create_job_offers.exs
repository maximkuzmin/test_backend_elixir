defmodule GeospatialApi.Repo.Migrations.CreateJobOffers do
  use Ecto.Migration

  def up do
    create table(:job_offers) do
      add :profession_id, references(:professions)
      add :contract_type, :string
      add :name, :string

      timestamps()
    end
    execute "CREATE EXTENSION IF NOT EXISTS postgis"
    # specify PostGIS point column
    execute("SELECT AddGeometryColumn ('job_offers','office_location',4326,'POINT',2);")
  end

  def down do
    drop table(:job_offers)
  end
end
