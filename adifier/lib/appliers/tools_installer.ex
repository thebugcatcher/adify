defmodule Adifier.Applier.ToolsInstaller do
  @moduledoc """
  """

  use Adifier.Applier

  require Logger

  @tool_modules ~w{Chromium Clang Curl Docker GoogleChrome
                  Mysql Neovim Nodejs Postgresql Ruby Spideroak 
                  VirtualBox Wget}a

  @impl true
  def run(os, noconfirm) do
    @tool_modules
    |> Enum.map(&Module.concat("Adifier.Tool", &1))
    |> Enum.map(&install_with_prompt(os, &1))

    {:ok, :done}
  end

  defp install_with_prompt(os, package) when is_binary(package) do
    proceed =
      IO.gets("""
      Adify wants to install package, #{package}.
      Proceed? (Y/N)
      """)

    case proceed do
      "Y" <> _tail ->
        Logger.info("""
        Installing package #{package}
        """)

        os
        |> Adifier.Tool.BasicTools.install_cmd(package)
        |> Adifier.Invoker.call()

      "y" <> _tail ->
        Logger.info("""
        Installing package #{package}
        """)

        os
        |> Adifier.Tool.BasicTools.install_cmd(package)
        |> Adifier.Invoker.call()

      _ ->
        Logger.warn("""
        Skipping package #{package}
        """)

        nil
    end
  end

  defp install_with_prompt(os, package) do
    proceed =
      IO.gets("""
      Adify wants to install package, #{package}.
      Proceed? (Y/N)
      """)

    case proceed do
      "Y" <> _tail ->
        Logger.info("""
        Installing package #{package}
        """)

        Elixir
        |> Module.concat(package)
        |> apply(:install_cmd, [os])
        |> Adifier.Invoker.call()

      "y" <> _tail ->
        Logger.info("""
        Installing package #{package}
        """)

        Elixir
        |> Module.concat(package)
        |> apply(:install_cmd, [os])
        |> Adifier.Invoker.call()

      _ ->
        Logger.warn("""
        Skipping package #{package}
        """)

        nil
    end
  end

  defp run_cmd(cmd) do
    System.cmd("sh", ["-c", cmd], into: IO.stream(:stdio, :line))
  end
end
