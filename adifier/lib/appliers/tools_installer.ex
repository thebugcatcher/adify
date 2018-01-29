defmodule Adifier.Applier.ToolsInstaller do
  @moduledoc """
  """

  @behaviour Adifier.Applier

  import Adifier.Tool

  @package_modules ~w(Wget Curl Chromium Docker GoogleChrome Mysql
    Neovim Nodejs Postgresql Spideroak)a

  @package_names ~w(wget curl)

  @packages @package_names ++ @package_modules

  def run(os) do
    Enum.map(@packages, &install_with_prompt(os, &1))
  end

  defp install_with_prompt(os, package) when is_binary(package) do
    proceed = IO.gets """
    Adify wants to install package, #{package}.
    Proceed? (Y/N)
    """
    case proceed do
      "Y" ->
        IO.puts """
        Installing package #{package}
        """

        os
        |> Adifier.Tool.BasicTools.install_cmd(package)
        |> run_cmd()

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
        |> run_cmd()
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

  defp run_cmd(cmd) do
    System.cmd("sh", ["-c" , cmd], into: IO.stream(:stdio, :line))
  end
end
