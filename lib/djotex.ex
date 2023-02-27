defmodule Djotex do
  @moduledoc """
  Documentation for `Djotex`.
  """

  @doc """
  Hello world.
  """
  def parse_to_ast(string) do
    Djotex.Parser.ast(string)
  end
end
