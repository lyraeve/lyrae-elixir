defmodule Lyrae do
  def main(args \\ []) do
    [head | _] = args
    Lyrae.Finder.find_by_number(head, :javbus)
  end
end

defmodule Lyrae.Lyr do
  defstruct title: "",
            number: "",
            cover: "",
            publish_at: "",
            length: "",
            producer: "",
            publisher: "",
            series: "",
            actors: [],
            genres: [],
            screenshots: []

  @type lyr_title :: binary | any
  @type lyr_number :: binary | any
  @type lyr_cover :: binary | any
  @type lyr_publish_at :: binary | any
  @type lyr_length :: binary | any
  @type lyr_producer :: binary | any
  @type lyr_publisher :: binary | any
  @type lyr_series :: binary | any
  @type lyr_actors :: [binary | any]
  @type lyr_genres :: [binary | any]
  @type lyr_screenshots :: [binary | any]
  @type t :: %__MODULE__{
          title: lyr_title,
          number: lyr_number,
          cover: lyr_cover,
          publish_at: lyr_publish_at,
          length: lyr_length,
          producer: lyr_producer,
          publisher: lyr_publisher,
          series: lyr_series,
          actors: lyr_actors,
          genres: lyr_genres,
          screenshots: lyr_screenshots
        }
end

defmodule Lyrae.Finder do
  def find_by_number(number, :javbus) do
    Lyrae.Finder.Javbus.find_by_number(number)
  end
end

defmodule Lyrae.Finder.Javbus do
  def find_by_number(number) do
    HTTPoison.get("https://www.javbus.com/" <> number)
    |> parse()
  end

  @spec parse(tuple) :: Lyrae.Lyr.t()

  def parse({:error, _}) do
    IO.puts("ERROR")
  end

  def parse({:ok, response}) do
    response.body
  end
end
