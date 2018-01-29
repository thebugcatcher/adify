defmodule Adifier.Applier.ToolsInstaller do
  @moduledoc """
  """

  @behaviour Adifier.Applier

  import Adifier.Tool

  @required_package_modules ~w(Wget Chromium Docker GoogleChrome Mysql Neovim
    Nodejs Postgresql Spideroak)a

  def run(os) do
    Enum.map(@required_package_modules, &install_with_prompt(os, &1))
  end

  defp install_with_prompt(os, package) do
    proceed = IO.gets """
    Adify wants to install package, #{package}.
    Proceed? (Y/N)
    """

    case proceed do
      "Y" ->
        IO.puts """
        Installing package #{package}
        """
        Elixir
        |> Module.concat(package)
        |> apply(:install_cmd, [os])
      "N" ->
        IO.warn """
        Skipping package #{package}
        """
      _ ->
        IO.warn """
        Unknown input #{proceed}, expected either Y or N.
        Skipping package #{package}
        """
    end
  end
end
