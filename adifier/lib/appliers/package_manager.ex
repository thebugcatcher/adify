defmodule Adifier.Applier.PackageManager do
  @moduledoc """
  """

  import Adifier.PackageManager

  def run(os) do
    os
    |> package_managers()
    |> Enum.map(&update_cmd/1)
  end
end
