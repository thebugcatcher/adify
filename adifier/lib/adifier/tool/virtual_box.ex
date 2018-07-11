defmodule Adifier.Tool.VirtualBox do
  @moduledoc """
  """

  use Adifier.Tool, name: "virtual_box"

  @impl true
  def install_cmd(:mac) do
    """
    brew cask install virtualbox
    """
  end

  @impl true
  def install_cmd(os), do: super(os)

  @impl true
  def description, do: @moduledoc
end
