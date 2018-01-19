defmodule Adifier.Applier.ToolsInstaller do
  @moduledoc """
  """

  @behaviour Adifier.Applier

  import Adifier.Tool

  @required ~w(chromium-browser wget neovim)
  @optional ~w(google-chrome-stable)

  def run(os), do: Enum.map(@required ++ @optional, &install_with_prompt(os, &1))

  defp install_with_prompt(os, package) do
    IO.puts """
    Installing package #{package}...
    """
    install(os, package)
  end
end
