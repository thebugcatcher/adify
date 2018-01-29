defmodule Adifier.Tool.BasicTools do
  @moduledoc """
  """

  @packages ~w(wget curl)

  def install_cmd(:ubuntu, package) when package in @packages do
    """
    sudo apt-get -y install #{package}
    """
  end
end
