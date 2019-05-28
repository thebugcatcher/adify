defmodule Adifier.Tool.Docker do
  @moduledoc """
  Docker enables true independence between applications and infrastructure
  and developers and IT ops to unlock their potential and creates a model
  for better collaboration and innovation.
  """

  use Adifier.Tool, name: "docker"

  @impl true
  def install_cmd(:mac) do
    """
    brew install docker docker-compose docker-machine xhyve docker-machine-driver-xhyve
    """
  end

  @impl true
  def install_cmd(os), do: super(os)

  @impl true
  def description, do: @moduledoc
end
