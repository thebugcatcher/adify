defmodule Adifier.Tool.Neovim do
  @moduledoc """
  """

  use Adifier.Tool

  def install_cmd(:ubuntu) do
    """
    sudo apt-get install neovim
    sudo apt-get install python-neovim
    sudo apt-get install python3-neovim
    """
  end

  def description() do
    """
		Neovim is a refactor, and sometimes redactor, in the tradition of Vim

		This is my main text editor!
		"""
  end
end
