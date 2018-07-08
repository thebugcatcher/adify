defmodule Adifier.Tool.GoogleChrome do
  @moduledoc """
  Google Chrome is a fast, secure, and free web browser, built for the modern web.
  """

  use Adifier.Tool, name: "google-chrome"

  @impl true
  def install_cmd(:ubuntu) do
    """
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
    sudo apt-get update
		sudo apt-get install google-chrome-stable
    """
  end
  def install_cmd(:arch_linux) do
    """
    git clone https://aur.archlinux.org/google-chrome.git ~/.adify/temp/tools/google-chrome/
    cd ~/.adify/temp/tools/google-chrome/
    makepkg -s --noconfirm
    sudo pacman -U --noconfirm google-chrome-*.pkg.tar.xz
    """
  end
  def install_cmd(:mac) do
    """
    brew install brew-cask
    brew cask install google-chrome
    """
  end
  def install_cmd(os), do: super(os)

  @impl true
  def description, do: @moduledoc
end
