defmodule Mix.Tasks.JobOffersByCategoryAndContinent do
  import Ecto.Query, only: [from: 2]

  @simple_doc "Outputs table of job_offers count by continent and profession category"
  def run(_) do
    Mix.Task.run "app.start"

    Services.JobOffersByCategoryAndContinent.call |> output
  end

  defp output({header, table}) do
    TableRex.quick_render!(table, header, "JobOffer by category and continent")
      |> IO.puts
  end
end
