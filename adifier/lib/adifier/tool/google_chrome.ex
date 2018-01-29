defmodule Adifier.Tool.GoogleChrome do
  @moduledoc """
  """

  use Adifier.Tool

  def install_cmd(:ubuntu) do
    """
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
    sudo apt-get update
		sudo apt-get install google-chrome-stable<Paste>
    """
  end

  def description() do
    """
		One fast, simple, and secure browser for all your devices.

    This is my browser for personal, non-work related usage.
		"""
  end
end
