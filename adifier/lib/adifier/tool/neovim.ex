defmodule Adifier.Tool.Neovim do
  @moduledoc """
  Neovim is a refactor, and sometimes redactor, in the tradition of Vim
  """

  use Adifier.Tool, name: "neovim"

  @impl true
  def install_cmd(os), do: super(os)

  @impl true
  def description, do: @moduledoc
end
