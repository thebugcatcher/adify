defmodule Adifier.Tool.Docker do
  @moduledoc """
  """

  use Adifier.Tool

  def install_cmd(:ubuntu) do
    """
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
		sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
		sudo apt-get update
		sudo apt-cache policy docker-ce
		sudo apt-get install -y docker-ce
		sudo systemctl status docker
    """
  end

  def description() do
    """
		Docker enables true independence between applications and infrastructure
		and developers and IT ops to unlock their potential and creates a model
		for better collaboration and innovation.

		I use docker for many things! Including elixir builds
		"""
  end
end
