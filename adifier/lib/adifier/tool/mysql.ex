defmodule Adifier.Tool.Mysql do
  @moduledoc """
  """

  use Adifier.Tool

  def install_cmd(:ubuntu) do
    """
    sudo apt-get update sudo apt-get install mysql-server
		/usr/bin/mysql_secure_installation
		sudo service mysql start
    """
  end

  def description() do
    """
		The most popular RDMS!

		You WILL need it!
		"""
  end
end
