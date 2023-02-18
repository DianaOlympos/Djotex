defmodule Djotex do
  @moduledoc """
  Documentation for `Djotex`.
  """

  @doc """
  Hello world.
  """
  def parse_to_events(string) do
    Djotex.Events.events(string)
  end
end
