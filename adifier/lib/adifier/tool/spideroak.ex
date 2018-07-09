defmodule Adifier.Tool.Spideroak do
  @moduledoc """
	This is a half decent backup tool!
  """

  use Adifier.Tool

  @impl true
  def install_cmd(:ubuntu) do
    """
    sudo sh -c "
    deb http://apt.spideroak.com/ubuntu-spideroak-hardy/ release restricted
		apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 573E3D1C51AE1B3D
		apt-get -y update
		apt-get -y install spideroakone
    "
    """
  end

  @impl true
  def install_cmd(:pop_os) do
    """
    sudo sh -c "
    deb http://apt.spideroak.com/ubuntu-spideroak-hardy/ release restricted
		apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 573E3D1C51AE1B3D
		apt-get -y update
		apt-get -y install spideroakone
    "
    """
  end

  @impl true
  def install_cmd(:arch_linux) do
    """
    sudo pacman -S spideroakgroups --noconfirm
    """
  end

  @impl true
  def description, do: @moduledoc
end
