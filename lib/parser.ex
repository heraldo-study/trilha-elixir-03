defmodule GenReport.Parser do
  def parse_csv(stream) do
    Enum.map(stream, fn el ->
      el
      |> String.trim()
      |> String.split(",")
      |> parse_lines()
    end)
  end

  defp parse_lines(lines) do
    [name, working_hours, day, month, year] = lines

    %{
      name: String.to_atom(name),
      working_hours: String.to_integer(working_hours),
      day: String.to_integer(day),
      month: parse_moutn(month),
      year: String.to_integer(year)
    }
  end

  defp parse_moutn(mouth) do
    case mouth do
      "1" -> :janeiro
      "2" -> :fevereiro
      "3" -> :março
      "4" -> :abril
      "5" -> :maio
      "6" -> :junho
      "7" -> :julho
      "8" -> :agosto
      "9" -> :setembro
      "10" -> :outubro
      "11" -> :novembro
      "12" -> :dezembro
    end
  end
end
