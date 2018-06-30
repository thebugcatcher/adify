defmodule Mix.Tasks.Adify do
  @moduledoc """
  This tasks runs a set of commands based on arguments provided.
  """

  use Mix.Task
  import Adifier

  @switches [os: :string, no_confirm: :boolean]
  @aliases [o: :os]

  def run(argv) do
    {parsed, _, _} =
      OptionParser.parse(argv, switches: @switches, aliases: @aliases)

      adify parsed
  end
end
