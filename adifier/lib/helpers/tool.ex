defmodule Adifier.Tool do
  @moduledoc """
  """

  @aptget ~w(chromium-browser google-chrome-stable neovim)
  @apt ~w(wget)
  @yum ~w(wget)
  @homebrew ~w(wget neovim)

  def install(:ubuntu, pkg) when pkg in @aptget, do: install_pkg("apt-get", pkg)
  def install(:ubuntu, pkg) when pkg in @apt, do: install_pkg("apt", pkg)
  def install(:centos, pkg) when pkg in @yum, do: install_pkg("yum", pkg)
  def install(:mac, pkg) when pkg in @homebrew, do: install_pkg("brew", pkg)
end
