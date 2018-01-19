defmodule Mix.Tasks.Adify do
  @moduledoc """
  This tasks runs a set of commands based on arguments provided.
  """

  use Mix.Task
  import Adifier

  @switches [os: :string, module: :keep]
  @aliases [o: :os, m: :module]

  def run(argv) do
    {parsed, _, _} =
      OptionParser.parse(argv, switches: @switches, aliases: @aliases)

      adify on: parsed[:os], apply: parsed[:mods]
  end
end
