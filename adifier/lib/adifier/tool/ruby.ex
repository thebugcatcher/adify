defmodule Adifier.Tool.Ruby do
  @moduledoc """
  """

  use Adifier.Tool

  @impl true
  def install_cmd(:ubuntu) do
    """
    asdf plugin-add ruby
    asdf install ruby 2.5.0
    """
  end

  @impl true
  def install_cmd(_os) do
    """
    asdf plugin-add ruby
    asdf install ruby 2.5.0
    """
  end

  @impl true
  def description, do: @moduledoc
end
