defmodule Adifier.PackageManager do
  @moduledoc """
  """

  @needsudo ~w(apt apt-get yum)

  def package_managers(:ubuntu), do: ~w(apt apt-get)
  def package_managers(:centos), do: ~w(yum)
  def package_managers(:mac), do: ~w(brew)

  def update_cmd(pm), do: "#{invoke_cmd(pm)} update"

  def invoke_cmd(pm) when pm in @needsudo, do: "sudo #{pm}"
  def invoke_cmd(pm), do: "#{pm}"
end
