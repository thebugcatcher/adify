defmodule Adifier.Tool.Postgresql do
  @moduledoc """
  """

  use Adifier.Tool

  def install_cmd(:ubuntu) do
    """
    sudo apt-get install linux-headers-$(uname -r) build-essential
		sudo apt-get install libreadline-dev
		asdf plugin-add postgres https://github.com/smashedtoatoms/asdf-postgres.git
		asdf install postgres 9.6.2
    """
  end

  def description() do
    """
		The second most popular RDMS!

		You WILL need it!
		"""
  end
end
