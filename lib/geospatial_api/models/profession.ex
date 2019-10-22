defmodule GeospatialApi.Profession do
  use Ecto.Schema
  import Ecto.Changeset

  schema "professions" do
    field :category_name, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(profession, attrs) do
    profession
      |> cast(attrs, [:name, :category_name])
      |> validate_required([:name, :category_name])
  end


  def import_changeset(profession, attrs) do
    changeset(profession, attrs) |> cast(attrs, [:id])
  end
end
