defmodule Adifier.Tool.Spideroak do
  @moduledoc """
  """

  use Adifier.Tool

  def install_cmd(:ubuntu) do
    """
    deb http://apt.spideroak.com/ubuntu-spideroak-hardy/ release restricted
		sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 573E3D1C51AE1B3D
		sudo apt-get update
		sudo apt-get install spideroakone
    """
  end

  def description() do
    """
		This is a half decent backup tool!
		"""
  end
end
