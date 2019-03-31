defmodule Lyrae do
  def main(args \\ []) do
    [head | _] = args
    lyr = Lyrae.Finder.find_by_number(head, :javbus)

    IO.puts("title: " <> lyr.title)
    IO.puts("number: " <> lyr.number)
    IO.puts("cover: " <> lyr.cover)
    IO.puts("publish_at: " <> lyr.publish_at)
    IO.puts("length: " <> lyr.length)
    IO.puts("producer: " <> lyr.producer)
    IO.puts("publisher: " <> lyr.publisher)
    IO.puts("series: " <> lyr.series)
    IO.puts("actors: ")
    IO.puts("genres: ")
    IO.puts("screenshots:")
    for screenshot <- lyr.screenshots, do: IO.puts("  " <> screenshot)
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
  @spec crawl(String.t()) :: String.t()
  @spec parse(tuple) :: Lyrae.Lyr.t()

  def find_by_number(number) do
    crawl(number)
    |> parse()
  end

  def crawl(number), do: HTTPoison.get!("https://www.javbus.com/" <> number).body

  def parse(body) do
    %Lyrae.Lyr{
      title: parse_title(body),
      number: "",
      cover: parse_cover(body),
      publish_at: "",
      length: "",
      producer: "",
      publisher: "",
      series: "",
      actors: [],
      genres: [],
      screenshots:
        parse_screenshots(body)
        |> build_screenshots()
    }
  end

  def build_screenshots(parsed) do
    for x <- parsed,
        do:
          Floki.attribute(x, "src")
          |> hd()
  end

  def parse_title(body),
    do:
      Floki.find(body, "h3")
      |> Floki.text()

  def parse_cover(body),
    do:
      Floki.find(body, ".movie .screencap img")
      |> Floki.attribute("src")
      |> hd()

  def parse_screenshots(body) do
    Floki.find(body, "#sample-waterfall .photo-frame img")
  end
end
