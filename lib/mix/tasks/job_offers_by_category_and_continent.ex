defmodule Mix.Tasks.JobOffersByCategoryAndContinent do
  import Ecto.Query, only: [from: 2]
  alias GeospatialApi.{JobOffer, Repo}

  @simple_doc "Outputs table of job_offers count by continent and profession category"
  def run(_) do
    Mix.Task.run "app.start"
    query()
      |> Repo.all
      |> transform_data
      |> output
  end

  defp query do
    from j in JobOffer,
         inner_join: p in "professions",
         on: j.profession_id == p.id,
         inner_join: c in "countries",
         #ecto "native" dsl cant use PostGIS ~ operator, so we use fragment macro
         on: fragment("? ~ ?", c.geom, j.office_location),
         group_by: [c.continent, p.category_name],
         select: [count(j.id), p.category_name, c.continent]
  end

  defp transform_data(raw_data) do
    mapped_raw_data = raw_data |> Enum.map(fn row -> map_from_row(row) end)

    categories = mapped_raw_data |> Enum.map(&(&1.category)) |> Enum.uniq |> Enum.sort
    categories = ["Total" | categories]

    by_continent = mapped_raw_data |> Enum.group_by(&(&1.continent))
    continents = ["Total" | Map.keys(by_continent) |> Enum.sort]
    by_continent = by_continent |> Map.put("Total", mapped_raw_data)

    table = for cont <- continents do
      data = categories |> Enum.map fn cat ->
          cont_data = by_continent[cont] || []
          cat_data = if cat == "Total" do
                      cont_data
                    else
                      cont_data |> Enum.filter(fn i -> i.category == cat end)
                    end
          cat_data = cat_data || []
          count = cat_data |> Enum.map(&(&1.count)) |> Enum.sum
          count
        end
      [cont|data]
    end
    header = ["Category" | categories]
    {header,table}
  end

  defp map_from_row(row) do
    count = row |> Enum.at(0)
    category = row |> Enum.at(1)
    continent = row |> Enum.at(2)
    %{count: count, category: category, continent: continent}
  end

  defp output({header, table}) do
    TableRex.quick_render!(table, header, "JobOffer by category and continent") |> IO.puts
  end
end
