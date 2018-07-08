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

  @impl true
  def install_cmd(:pop_os) do
    """
    sudo apt-get -y install mysql-server
		/usr/bin/mysql_secure_installation
		sudo systemctl start mysql
    """
  end

  @impl true
  def install_cmd(:arch_linux) do
    """
    sudo pacman -S mariadb
    """
  end

  @impl true
  def install_cmd(os), do: super(os)

  @impl true
  def description, do: @moduledoc
end
