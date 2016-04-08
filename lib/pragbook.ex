defmodule Pragbook do

  def main([]) do
    get_month
    |> (fn n -> [n] end).()
    |> main
  end
  
  def main([month]) do
    site = HTTPotion.get("http://pragprog.elixirforum.com/#{month}").body

    entries = site
    |> Floki.find(".thismonthsentriestable")
    |> hd
    |> get_childs
    |> tl
    |> Enum.map(&combine_rows/1)
    |> Enum.map(&clean/1)
    # |> IO.inspect

    number = site
    |> Floki.find(".thismonthsnumber")
    |> hd
    |> get_childs
    |> hd
    |> String.to_integer

    entries
    |> Enum.map(&inject_difference(&1, number))
    |> Enum.sort
    |> hd
    |> print_result(number)
  end

  defp get_childs({_, _, childs}) when is_list(childs), do: childs

  defp combine_rows({"tr", _, [{"td", _, [score]}, {"td", _, [name_stuff]}]}) do
    {score, name_stuff}
  end

  defp clean({score_str, name_stuff}) do
    score = String.to_integer(score_str)
    name = Regex.named_captures(~r/\s+(?<nick>\pL+)/, name_stuff)["nick"]
    {score, name}
  end

  defp inject_difference({this, name}, number), do: {abs(number - this), this, name}

  defp print_result({diff, ticket, name}, target), do: IO.puts "#{name} had the ticket #{ticket} which is only #{diff} away from #{target}"

  defp get_month do
    :calendar.universal_time
    |> (fn ({{_, m, _}, _}) -> m end).()
    |> make_month_name_from_int
  end

  defp make_month_name_from_int(1), do: "january"
  defp make_month_name_from_int(2), do: "february"
  defp make_month_name_from_int(3), do: "march"
  defp make_month_name_from_int(4), do: "april"
  defp make_month_name_from_int(5), do: "may"
  defp make_month_name_from_int(6), do: "june"
  defp make_month_name_from_int(7), do: "july"
  defp make_month_name_from_int(8), do: "august"
  defp make_month_name_from_int(9), do: "septembre"
  defp make_month_name_from_int(10), do: "octobre"
  defp make_month_name_from_int(11), do: "novembre"
  defp make_month_name_from_int(12), do: "decembre"
end
