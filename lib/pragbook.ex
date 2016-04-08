defmodule Pragbook do

  def main([]) do
    site = HTTPotion.get("http://pragprog.elixirforum.com/april").body

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
end
