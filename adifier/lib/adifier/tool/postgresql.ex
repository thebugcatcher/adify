defmodule Adifier.Tool.Postgresql do
  @moduledoc """
  The second most popular RDMS!

  You WILL need it!
  """

  use Adifier.Tool

  @impl true
  def install_cmd(:ubuntu) do
    """
    sudo sh -c "
    apt-get -y install linux-headers-$(uname -r) build-essential
    apt-get -y install libreadline-dev
    asdf plugin-add postgres https://github.com/smashedtoatoms/asdf-postgres.git
    asdf install postgres 9.6.2
    "
    """
  end

  @impl true
  def install_cmd(:pop_os) do
    """
    sudo sh -c "
    apt-get -y install linux-headers-$(uname -r) build-essential
    apt-get -y install libreadline-dev
    asdf plugin-add postgres https://github.com/smashedtoatoms/asdf-postgres.git
    asdf install postgres 9.6.2
    "
    """
  end

  @impl true
  def install_cmd(_os) do
    """
    asdf plugin-add postgres https://github.com/smashedtoatoms/asdf-postgres.git
    asdf install postgres 9.6.2
    """
  end

  @impl true
  def description, do: @moduledoc
end
