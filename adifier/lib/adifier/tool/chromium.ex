defmodule Adifier.Tool.Chromium do
  @moduledoc """
  Chromium is an open-source browser project that aims to build a safer,
  faster, and more stable way for all Internet users to experience the web.
  """

  use Adifier.Tool, name: "chromium-browser"

  @impl true
  def install_cmd(:mac) do
    """
    brew tap domt4/chromium
    brew cask install mac-chromium
    """
  end
  def install_cmd(os), do: super(os)

  @impl true
  def description, do: @moduledoc
end
