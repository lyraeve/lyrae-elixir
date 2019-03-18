defmodule Lyrae do
  @moduledoc """
  Documentation for Lyrae.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Lyrae.hello()
      :world

  """
  def hello do
    IO.puts "hello world"
  end

  def main(args \\ []) do
    IO.puts "hello world"
    IO.puts args
  end
end
