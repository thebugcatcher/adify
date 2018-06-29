defmodule Adifier.Tool.Docker do
  @moduledoc """
	Docker enables true independence between applications and infrastructure
	and developers and IT ops to unlock their potential and creates a model
	for better collaboration and innovation.
  """

  use Adifier.Tool, name: "docker"

  @impl true
  def install_cmd(:mac), do: "brew install docker"
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
  def install_cmd(:debian), do: "sudo apt install -y docker"
  def install_cmd(os), do: super(os)

  @impl true
  def description, do: @moduledoc
end
