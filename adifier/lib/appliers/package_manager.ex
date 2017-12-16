defmodule Adifier.Applier.PackageManager do
  @moduledoc """
  """

  @behaviour Adifier.Applier

  import Adifier.PackageManager

  def run(os) do
    os
    |> package_managers()
    |> Enum.map(&update_cmd/1)
  end
end
