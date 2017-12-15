defmodule Mix.Tasks.Apply do
  @moduledoc """
  This tasks runs a set of commands based on arguments provided.
  """

  use Mix.Task
  import Adifier

  @switches [os: :string, concatenatedmods: :string]
  @aliases [o: :os, m: :concatenatedmods]

  def run(argv) do
    {parsed, _, _} =
      OptionParser.parse(argv, switches: @switches, aliases: @aliases)

      adify on: parsed[:os], apply: parsed[:concatenatedmods]
  end
end
