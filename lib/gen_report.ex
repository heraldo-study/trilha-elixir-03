defmodule GenReport do
  alias GenReport.Parser

  def call do
    "reports/gen_report.csv"
    |> File.stream!()
    |> Parser.parse_csv()
    |> gen_report()
  end

  defp gen_report(data) do
    all_hours_task = Task.async(fn -> gen_all_hours(data) end)
    hours_per_month_task = Task.async(fn -> gen_hours_per_month(data) end)
    hours_per_year_task = Task.async(fn -> hours_per_year(data) end)

    %{
      all_hours: Task.await(all_hours_task),
      hours_per_month: Task.await(hours_per_month_task),
      hours_per_year: Task.await(hours_per_year_task)
    }
  end

  defp gen_all_hours(data) do
    data
    |> Enum.reduce(%{}, fn %{name: name, working_hours: hours}, acc ->
      if acc[name] == nil,
        do: Map.put(acc, name, hours),
        else: Map.put(acc, name, acc[name] + hours)
    end)
  end

  defp gen_hours_per_month(data) do
    data
    |> Enum.reduce(%{}, fn %{name: name, working_hours: hours, month: month}, acc ->
      if acc[name] == nil do
        Map.put(acc, name, %{month => hours})
      else
        if acc[name][month] == nil do
          Map.put(acc, name, Map.put(acc[name], month, hours))
        else
          Map.put(acc, name, Map.put(acc[name], month, acc[name][month] + hours))
        end
      end
    end)
  end

  defp hours_per_year(data) do
    data
    |> Enum.reduce(%{}, fn %{name: name, working_hours: hours, year: year}, acc ->
      if acc[name] == nil do
        Map.put(acc, name, %{year => hours})
      else
        if acc[name][year] == nil do
          Map.put(acc, name, Map.put(acc[name], year, hours))
        else
          Map.put(acc, name, Map.put(acc[name], year, acc[name][year] + hours))
        end
      end
    end)
  end
end
