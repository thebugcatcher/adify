defmodule Adifier.Applier.ToolsInstaller do
  @moduledoc """
  """

  @behaviour Adifier.Applier

  import Adifier.Tool

  @required_package_modules ~w(Chromium Docker GoogleChrome Mysql Neovim Nodejs
    Postgresql Spideroak)a

  @required_packages ~w(wget) ++ @required_package_modules

  def run(os), do: Enum.map(@required ++ @optional, &install_with_prompt(os, &1))

  defp install_with_prompt(os, package), when is_binary(package) do
    IO.puts """
    Installing package #{package}...
    """
    install(os, package)
  end
  defp install_with_prompt(os, package) do
    IO.puts """
    Installing package #{package}...
    """
    Elixir
    |> Module.concat(package)
    |> apply(:install_cmd, [os])
  end
end
