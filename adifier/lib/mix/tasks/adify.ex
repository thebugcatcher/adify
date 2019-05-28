defmodule Mix.Tasks.Adify do
  @moduledoc """
  This tasks runs a set of commands based on arguments provided.
  """

  use Mix.Task
  import Adifier

  @switches [os: :string, noconfirm: :boolean, pm: :boolean]
  @aliases [o: :os]

  def run(argv) do
    {parsed, _, _} = OptionParser.parse(argv, switches: @switches, aliases: @aliases)

    appliers = ~w{ToolsInstaller Configurations}

    appliers =
      case Keyword.get(parsed, :pm, nil) do
        true -> ["PackageManagerUpdater"] ++ appliers
        _ -> appliers
      end

    appliers = Keyword.put(parsed, :appliers, appliers)

    adify(parsed)
  end
end
