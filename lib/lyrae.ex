defmodule Lyrae do
  def main(args \\ []) do
    [head | _] = args
    Lyrae.Finder.find_by_number(head, :javbus)
  end
end

defmodule Lyrae.Finder do
  def find_by_number(number, :javbus) do
    Lyrae.Finder.Javbus.find_by_number(number)
  end
end

defmodule Lyrae.Finder.Javbus do
  def find_by_number(number) do
    HTTPoison.get("https://www.javbus.com/" <> number) |> parse()
  end

  def parse {:error, _} do IO.puts "ERROR" end
  def parse {:ok, response} do
    response.body
  end
end
