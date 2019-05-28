defmodule Adifier do
  @moduledoc """
  Documentation for Adifier.
  """

  @appliers ~w(PackageManagerUpdater ToolsInstaller Configurations)
  @default_os "ubuntu"

  def adify(opts) do
    os =
      opts
      |> Keyword.get(:os, @default_os)
      |> String.to_atom()

    noconfirm = Keyword.get(opts, :noconfirm, false)

    appliers = Keyword.get(opts, :appliers, @appliers)

    appliers
    |> Enum.map(&Module.concat("Adifier.Applier", &1))
    |> Enum.reduce({:ok, :done}, fn
      applier, {:ok, :done} -> applier.run(os, noconfirm)
      applier, {:error, reason} -> {:error, reason}
    end)
  end
end
