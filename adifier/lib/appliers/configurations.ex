defmodule Adifier.Applier.Configurations do
  @moduledoc """
  """

  require Logger

  @behaviour Adifier.Applier

  def run(os, noconfirm) do
    Logger.warn("No Configurations setup")
  end
end
