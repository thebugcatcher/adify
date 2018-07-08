defmodule Adifier.Applier.ToolsInstaller do
  @moduledoc """
  """

  use Adifier.Applier

  @tool_modules ~w{Chromium Clang Curl Docker Docker GoogleChrome
                  Mysql Neovim Nodejs Postgresql Spideroak Wget}a

  @impl true
  def run(os, noconfirm) do
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
