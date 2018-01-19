defmodule Adifier.Applier.ToolsInstaller do
  @moduledoc """
  """

  @behaviour Adifier.Applier

  import Adifier.Tool

  @required ~w(chromium-browser wget neovim)
  @optional ~w(google-chrome-stable)

  def run(os), do: Enum.map(@required ++ @optional, &install(os, &1))
end
