defmodule Adifier.Tool.Mysql do
  @moduledoc """
	The most popular Open-source Relational Database Mangement System.
  """

  use Adifier.Tool, name: "mysql"

  @impl true
  def install_cmd(:ubuntu) do
    """
    sudo apt-get -y install mysql-server
		/usr/bin/mysql_secure_installation
		sudo systemctl start mysql
    """
  end
  def install_cmd(os), do: super(os)

  @impl true
  def description, do: @moduledoc
end
