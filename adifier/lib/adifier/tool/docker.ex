defmodule Adifier.Tool.Docker do
  @moduledoc """
	Docker enables true independence between applications and infrastructure
	and developers and IT ops to unlock their potential and creates a model
	for better collaboration and innovation.
  """

  use Adifier.Tool, name: "docker"

  @impl true
  def install_cmd(:ubuntu) do
    """
    sudo sh -c "
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
		add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
		apt-get -y update
		apt-cache policy docker-ce
		apt-get install -y docker-ce
		systemctl status docker
    "
    """
  end

  @impl true
  def install_cmd(:pop_os) do
    """
    sudo sh -c "
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
		add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
		apt-get -y update
		apt-cache policy docker-ce
		apt-get install -y docker-ce
		systemctl status docker
    "
    """
  end

  @impl true
  def install_cmd(os), do: super(os)

  @impl true
  def description, do: @moduledoc
end
