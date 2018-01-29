defmodule Adifier.Tool.Chromium do
  @moduledoc """
  """

  use Adifier.Tool

  def install_cmd(:ubuntu) do
    """
    sudo apt install chromium-browser
    """
  end

  def description() do
    """
    Chromium is an open-source browser project that aims to build a safer,
    faster, and more stable way for all Internet users to experience the web.

    This is my default browser, as I don't have to worry about the RAM usage
    a lot
    """
  end
end
