defmodule Adifier do
  @moduledoc """
  Documentation for Adifier.
  """

  @defaultmods ~w(PackageManagerUpdater Tools Configurations)
  @default_os :ubuntu

  def adify(on: os, apply: mods) do
    mods
    |> modules()
    |> Enum.each(&apply(&1, :run, [os || @default_os]))
  end

  defp modules(nil), do: modules(@defaultmods)
  defp modules(concatenatedmods) when is_binary(concatenatedmods) do
    concatenatedmods
    |> String.split(",")
    |> Enum.each(&String.trim/1)
    |> Enum.uniq()
    |> modules()
  end
  defp modules(mods) do
    Enum.map(mods, &Module.concat("Adifier.Applier", &1))
  end
end
